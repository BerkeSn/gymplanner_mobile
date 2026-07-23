// presentation/controllers/body_measurement_controller.dart

import 'package:gymplanner_mobile/features/body_measurement/domain/entites/body_measurement_entity.dart';
import 'package:gymplanner_mobile/features/body_measurement/domain/entites/measurement_goal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/body_measurement_providers.dart';

part 'body_measurement_controller.g.dart';

@Riverpod(keepAlive: true)
class BodyMeasurementController
    extends _$BodyMeasurementController {
  @override
  FutureOr<List<BodyMeasurementEntity>>
  build() async {
    return _fetch();
  }

  Future<List<BodyMeasurementEntity>>
  _fetch() async {
    try {
      final repository = ref.read(
        bodyMeasurementRepositoryProvider,
      );
      final result = await repository
          .getAllMeasurements();
      if (result
          is Failure<
            List<BodyMeasurementEntity>
          >) {
        throw result.exception;
      }
      return (result
              as Success<
                List<BodyMeasurementEntity>
              >)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'BodyMeasurementController - _fetch',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> refresh() async {
    state =
        const AsyncLoading<
              List<BodyMeasurementEntity>
            >()
            .copyWithPrevious(state);
    state = await AsyncValue.guard(_fetch);
  }

  /// Faz 1'de signup akışında Height/Weight girildiğinde çağrılır, ayrıca
  /// normal "Ölçüm Ekle" formundan da çağrılır — TEK GİRİŞ NOKTASI.
  Future<bool> addMeasurement({
    DateTime? date,
    required double weight,
    required double height,
    double? neck,
    double? waist,
    double? bodyFatPercentage,
    MeasurementGoal? goal,
  }) async {
    try {
      final repository = ref.read(
        bodyMeasurementRepositoryProvider,
      );
      final result = await repository
          .createMeasurement(
            date: date,
            weight: weight,
            height: height,
            neck: neck,
            waist: waist,
            bodyFatPercentage: bodyFatPercentage,
            goal: goal,
          );
      if (result
          is Failure<BodyMeasurementEntity>) {
        throw result.exception;
      }
      await refresh();
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'BodyMeasurementController - addMeasurement',
        error,
        stackTrace,
      );
      return false;
    }
  }

  Future<void> deleteMeasurement(int id) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final optimisticList = current
        .where((m) => m.id != id)
        .toList();
    state = AsyncData(optimisticList);

    try {
      final repository = ref.read(
        bodyMeasurementRepositoryProvider,
      );
      final result = await repository
          .deleteMeasurement(id);
      if (result is Failure<void>) {
        throw result.exception;
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'BodyMeasurementController - deleteMeasurement',
        error,
        stackTrace,
      );
      state = AsyncData(current); // geri al
    }
  }
}
