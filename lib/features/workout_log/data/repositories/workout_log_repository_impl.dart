// repositories/workout_log_repository_impl.dart

import 'package:gymplanner_mobile/features/workout_log/domain/entites/streak_analytics_entity.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_log_entity.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_set_entity.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/workout_log_repository.dart';
import '../datasources/workout_log_remote_datasource.dart';

class WorkoutLogRepositoryImpl
    implements WorkoutLogRepository {
  final WorkoutLogRemoteDataSource
  _remoteDataSource;
  const WorkoutLogRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<StreakAnalyticsEntity>>
  getStreakAnalytics() async {
    try {
      final dto = await _remoteDataSource
          .getStreakAnalytics();
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutLogRepositoryImpl - getStreakAnalytics',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<WorkoutLogEntity>>>
  getWorkoutLogs() async {
    try {
      final dtos = await _remoteDataSource
          .getWorkoutLogs();
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
              'WorkoutLogRepositoryImpl - getWorkoutLogs',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<WorkoutLogEntity>>
  startWorkoutLog(int workoutRoutineId) async {
    try {
      final dto = await _remoteDataSource
          .startWorkoutLog(workoutRoutineId);
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutLogRepositoryImpl - startWorkoutLog',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<WorkoutSetEntity>> addSet({
    required int workoutLogId,
    required int exerciseId,
    required int setNumber,
    required int reps,
    required double weight,
  }) async {
    try {
      final dto = await _remoteDataSource.addSet(
        workoutLogId: workoutLogId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        reps: reps,
        weight: weight,
      );
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutLogRepositoryImpl - addSet',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> removeSet({
    required int workoutLogId,
    required int setId,
  }) async {
    try {
      await _remoteDataSource.removeSet(
        workoutLogId: workoutLogId,
        setId: setId,
      );
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutLogRepositoryImpl - removeSet',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
