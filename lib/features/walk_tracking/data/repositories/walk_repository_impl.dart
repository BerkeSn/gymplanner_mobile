// repositories/walk_repository_impl.dart

import 'package:gymplanner_mobile/features/walk_tracking/data/datasource/walk_remote_datasource.dart';
import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/lat_lng_entity.dart';
import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/walk_session_entity.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/walk_repository.dart';
import '../models/lat_lng_dto.dart';

class WalkRepositoryImpl
    implements WalkRepository {
  final WalkRemoteDataSource _remoteDataSource;
  const WalkRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<WalkSessionEntity>> logWalk({
    required DateTime startTime,
    required DateTime endTime,
    required int durationSeconds,
    required double distanceMeters,
    required int steps,
    required int calories,
    required List<LatLngEntity> routePoints,
  }) async {
    try {
      final dto = await _remoteDataSource.logWalk(
        startTime: startTime.toIso8601String(),
        endTime: endTime.toIso8601String(),
        durationSeconds: durationSeconds,
        distanceMeters: distanceMeters,
        steps: steps,
        calories: calories,
        routePoints: routePoints
            .map(
              (p) => LatLngDto(
                lat: p.lat,
                lng: p.lng,
              ),
            )
            .toList(),
      );
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source: 'WalkRepositoryImpl - logWalk',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<WalkSessionEntity>>>
  getWalkHistory() async {
    try {
      final dtos = await _remoteDataSource
          .getWalkHistory();
      return Success(
        dtos
            .map((dto) => dto.toEntity())
            .toList(),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WalkRepositoryImpl - getWalkHistory',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<WalkSessionEntity>> getWalkById(
    int id,
  ) async {
    try {
      final dto = await _remoteDataSource
          .getWalkById(id);
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WalkRepositoryImpl - getWalkById',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
