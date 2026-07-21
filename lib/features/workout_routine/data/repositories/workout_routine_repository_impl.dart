// repositories/workout_routine_repository_impl.dart

import 'package:gymplanner_mobile/features/workout_routine/domain/entities/workout_routine_entity.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/week_day.dart';
import '../../domain/repositories/workout_routine_repository.dart';
import '../datasources/workout_routine_remote_datasource.dart';

class WorkoutRoutineRepositoryImpl
    implements WorkoutRoutineRepository {
  final WorkoutRoutineRemoteDataSource
  _remoteDataSource;
  const WorkoutRoutineRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<List<WorkoutRoutineEntity>>>
  getWorkoutRoutines() async {
    try {
      final dtos = await _remoteDataSource
          .getWorkoutRoutines();
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
              'WorkoutRoutineRepositoryImpl - getWorkoutRoutines',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<WorkoutRoutineEntity>>
  createWorkoutRoutine({
    required String name,
    String? description,
  }) async {
    try {
      final dto = await _remoteDataSource
          .createWorkoutRoutine(
            name: name,
            description: description,
          );
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutRoutineRepositoryImpl - createWorkoutRoutine',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> updateWorkoutRoutine({
    required int id,
    String? name,
    String? description,
    bool? isActive,
  }) async {
    try {
      await _remoteDataSource
          .updateWorkoutRoutine(
            id: id,
            name: name,
            description: description,
            isActive: isActive,
          );
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutRoutineRepositoryImpl - updateWorkoutRoutine',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteWorkoutRoutine(
    int id,
  ) async {
    try {
      await _remoteDataSource
          .deleteWorkoutRoutine(id);
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutRoutineRepositoryImpl - deleteWorkoutRoutine',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<int>> addExerciseToRoutine({
    required int routineId,
    required int exerciseId,
    required WeekDay day,
    required int targetSets,
    required int targetReps,
  }) async {
    try {
      final newId = await _remoteDataSource
          .addExerciseToRoutine(
            routineId: routineId,
            exerciseId: exerciseId,
            day: day.apiValue,
            targetSets: targetSets,
            targetReps: targetReps,
          );
      return Success(newId);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutRoutineRepositoryImpl - addExerciseToRoutine',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteRoutineExercise(
    int routineExerciseId,
  ) async {
    try {
      await _remoteDataSource
          .deleteRoutineExercise(
            routineExerciseId,
          );
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'WorkoutRoutineRepositoryImpl - deleteRoutineExercise',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
