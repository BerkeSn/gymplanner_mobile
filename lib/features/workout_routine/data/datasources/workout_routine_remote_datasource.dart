// datasources/workout_routine_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/workout_routine_dto.dart';

class WorkoutRoutineRemoteDataSource {
  final Dio _dio;
  const WorkoutRoutineRemoteDataSource(this._dio);

  Future<List<WorkoutRoutineDto>>
  getWorkoutRoutines() async {
    try {
      final response = await _dio.get(
        '/workoutroutine/getWorkoutRoutines',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['workoutRoutines']
              as List<dynamic>;
      return list
          .map(
            (json) => WorkoutRoutineDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WorkoutRoutineRemoteDataSource - getWorkoutRoutines',
        message:
            _extractMessage(error) ??
            'Programlar alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WorkoutRoutineRemoteDataSource - getWorkoutRoutines',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<WorkoutRoutineDto> createWorkoutRoutine({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        '/workoutroutine/createWorkoutRoutine',
        data: {
          'name': name,
          if (description != null &&
              description.isNotEmpty)
            'description': description,
        },
      );
      final data =
          response.data as Map<String, dynamic>;
      return WorkoutRoutineDto.fromJson(
        data['workoutRoutine']
            as Map<String, dynamic>,
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WorkoutRoutineRemoteDataSource - createWorkoutRoutine',
        message:
            _extractMessage(error) ??
            'Program oluşturulamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WorkoutRoutineRemoteDataSource - createWorkoutRoutine',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> updateWorkoutRoutine({
    required int id,
    String? name,
    String? description,
    bool? isActive,
  }) async {
    try {
      await _dio.post(
        '/workoutroutine/updateWorkoutRoutine/$id',
        data: {
          if (name != null) 'name': name,
          if (description != null)
            'description': description,
          if (isActive != null)
            'isActive': isActive,
        },
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WorkoutRoutineRemoteDataSource - updateWorkoutRoutine',
        message:
            _extractMessage(error) ??
            'Program güncellenemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WorkoutRoutineRemoteDataSource - updateWorkoutRoutine',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteWorkoutRoutine(
    int id,
  ) async {
    try {
      await _dio.delete(
        '/workoutroutine/deleteWorkoutRoutine/$id',
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WorkoutRoutineRemoteDataSource - deleteWorkoutRoutine',
        message:
            _extractMessage(error) ??
            'Program silinemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WorkoutRoutineRemoteDataSource - deleteWorkoutRoutine',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<int> addExerciseToRoutine({
    required int routineId,
    required int exerciseId,
    required String day,
    required int targetSets,
    required int targetReps,
  }) async {
    try {
      final response = await _dio.post(
        '/routineexercise/addExerciseToRoutine/$routineId',
        data: {
          'exerciseId': exerciseId,
          'day': day,
          'targetSets': targetSets,
          'targetReps': targetReps,
        },
      );
      final data =
          response.data as Map<String, dynamic>;
      final addedExercise =
          data['addedExercise']
              as Map<String, dynamic>;
      return addedExercise['id'] as int;
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WorkoutRoutineRemoteDataSource - addExerciseToRoutine',
        message:
            _extractMessage(error) ??
            'Hareket programa eklenemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WorkoutRoutineRemoteDataSource - addExerciseToRoutine',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteRoutineExercise(
    int routineExerciseId,
  ) async {
    try {
      await _dio.delete(
        '/routineexercise/deleteRoutineExercise/$routineExerciseId',
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WorkoutRoutineRemoteDataSource - deleteRoutineExercise',
        message:
            _extractMessage(error) ??
            'Hareket silinemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WorkoutRoutineRemoteDataSource - deleteRoutineExercise',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] ?? data['error'])
          ?.toString();
    }
    return null;
  }
}
