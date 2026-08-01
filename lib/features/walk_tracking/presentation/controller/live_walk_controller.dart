// presentation/controllers/live_walk_controller.dart

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:gymplanner_mobile/features/body_measurement/presentation/controller/body_measurement_controller.dart';
import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/lat_lng_entity.dart';
import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/walk_session_entity.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/walk_providers.dart';

part 'live_walk_controller.g.dart';

class LiveWalkState {
  final bool isTracking;
  final bool isPaused;
  final int elapsedSeconds;
  final double distanceMeters;
  final int steps;
  final List<LatLngEntity> routePoints;

  const LiveWalkState({
    this.isTracking = false,
    this.isPaused = false,
    this.elapsedSeconds = 0,
    this.distanceMeters = 0,
    this.steps = 0,
    this.routePoints = const [],
  });

  LiveWalkState copyWith({
    bool? isTracking,
    bool? isPaused,
    int? elapsedSeconds,
    double? distanceMeters,
    int? steps,
    List<LatLngEntity>? routePoints,
  }) {
    return LiveWalkState(
      isTracking: isTracking ?? this.isTracking,
      isPaused: isPaused ?? this.isPaused,
      elapsedSeconds:
          elapsedSeconds ?? this.elapsedSeconds,
      distanceMeters:
          distanceMeters ?? this.distanceMeters,
      steps: steps ?? this.steps,
      routePoints:
          routePoints ?? this.routePoints,
    );
  }
}

/// Tek bir aktif yürüyüş oturumunu yönetir: GPS ile mesafe/rota, pedometer
/// ile adım sayısı, Timer ile süre. autoDispose (varsayılan @riverpod) —
/// aktif yürüyüş ekranından çıkınca sensör dinleyicileri temizlenmeli.
@riverpod
class LiveWalkController
    extends _$LiveWalkController {
  StreamSubscription<Position>? _positionSub;
  StreamSubscription<StepCount>? _stepSub;
  Timer? _timer;
  DateTime? _startTime;
  int? _stepBaseline;

  @override
  LiveWalkState build() {
    ref.onDispose(() {
      _positionSub?.cancel();
      _stepSub?.cancel();
      _timer?.cancel();
    });
    return const LiveWalkState();
  }

  Future<bool> start() async {
    try {
      final hasLocationPermission =
          await _ensureLocationPermission();
      if (!hasLocationPermission) return false;

      await Permission.activityRecognition
          .request();

      _startTime = DateTime.now();
      state = state.copyWith(
        isTracking: true,
        isPaused: false,
      );

      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          if (!state.isPaused) {
            state = state.copyWith(
              elapsedSeconds:
                  state.elapsedSeconds + 1,
            );
          }
        },
      );

      _positionSub =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter:
                  5, // 5 metreden az hareket -> güncelleme yok, gürültü azaltma.
            ),
          ).listen(
            _onPositionUpdate,
            onError: (error) {
              AppLogger.error(
                'LiveWalkController - positionStream',
                error,
              );
            },
          );

      _stepSub = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: (error) {
          AppLogger.error(
            'LiveWalkController - stepCountStream',
            error,
          );
        },
      );

      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'LiveWalkController - start',
        error,
        stackTrace,
      );
      return false;
    }
  }

  Future<bool> _ensureLocationPermission() async {
    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      var permission =
          await Geolocator.checkPermission();
      if (permission ==
          LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }
      return permission ==
              LocationPermission.always ||
          permission ==
              LocationPermission.whileInUse;
    } catch (error, stackTrace) {
      AppLogger.error(
        'LiveWalkController - _ensureLocationPermission',
        error,
        stackTrace,
      );
      return false;
    }
  }

  void _onPositionUpdate(Position position) {
    if (state.isPaused) return;
    try {
      final newPoint = LatLngEntity(
        lat: position.latitude,
        lng: position.longitude,
      );
      final updatedPoints = [
        ...state.routePoints,
        newPoint,
      ];

      double addedDistance = 0;
      if (state.routePoints.isNotEmpty) {
        final last = state.routePoints.last;
        addedDistance =
            Geolocator.distanceBetween(
              last.lat,
              last.lng,
              newPoint.lat,
              newPoint.lng,
            );
      }

      state = state.copyWith(
        routePoints: updatedPoints,
        distanceMeters:
            state.distanceMeters + addedDistance,
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'LiveWalkController - _onPositionUpdate',
        error,
        stackTrace,
      );
    }
  }

  void _onStepCount(StepCount event) {
    try {
      // Pedometer, cihaz açıldığından beri KÜMÜLATİF adım sayısı verir —
      // oturumun başındaki değeri taban alıp farkı hesaplıyoruz.
      _stepBaseline ??= event.steps;
      final sessionSteps =
          event.steps - _stepBaseline!;
      if (sessionSteps >= 0) {
        state = state.copyWith(
          steps: sessionSteps,
        );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'LiveWalkController - _onStepCount',
        error,
        stackTrace,
      );
    }
  }

  void togglePause() {
    state = state.copyWith(
      isPaused: !state.isPaused,
    );
  }

  /// Oturumu sonlandırır, backend'e kaydeder ve kaydedilen entity'yi döner.
  /// Hata olursa null döner — çağıran taraf UI'da hata göstermeli.
  Future<WalkSessionEntity?> finish() async {
    try {
      _timer?.cancel();
      await _positionSub?.cancel();
      await _stepSub?.cancel();

      final endTime = DateTime.now();
      final startTime = _startTime ?? endTime;

      // Kalori tahmini: standart MET formülü (3.8 MET = tempolu yürüyüş).
      // Gerçek ölçüme dayalı en son kilo bilgisini kullanır, yoksa 70kg
      // varsayılan ile KABA bir tahmin üretir — kesin tıbbi veri değildir.
      final latestWeight =
          ref
              .read(
                bodyMeasurementControllerProvider,
              )
              .valueOrNull
              ?.firstOrNull
              ?.weight ??
          70.0;
      const walkingMet = 3.8;
      final hours = state.elapsedSeconds / 3600;
      final estimatedCalories =
          (walkingMet * latestWeight * hours)
              .round();

      final repository = ref.read(
        walkRepositoryProvider,
      );
      final result = await repository.logWalk(
        startTime: startTime,
        endTime: endTime,
        durationSeconds: state.elapsedSeconds,
        distanceMeters: state.distanceMeters,
        steps: state.steps,
        calories: estimatedCalories,
        routePoints: state.routePoints,
      );

      if (result is Failure<WalkSessionEntity>) {
        throw result.exception;
      }

      state =
          const LiveWalkState(); // Bir sonraki yürüyüş için sıfırla.
      return (result
              as Success<WalkSessionEntity>)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'LiveWalkController - finish',
        error,
        stackTrace,
      );
      return null;
    }
  }
}
