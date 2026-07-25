// datasources/workout_log_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/workout_log_dto.dart';
import '../models/workout_set_dto.dart';

class WorkoutLogRemoteDataSource {
  final Dio _dio;
  const WorkoutLogRemoteDataSource(this._dio);

  Future<WorkoutLogDto> startWorkoutLog(int workoutRoutineId) async {
    try {
      final response =
          await _dio.post('/workoutlogs/startWorkoutLog/$workoutRoutineId');
      final data = response.data as Map<String, dynamic>;
      return WorkoutLogDto.fromJson(data['workoutLog'] as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source: 'WorkoutLogRemoteDataSource - startWorkoutLog',
        message: _extractMessage(error) ?? 'Antrenman oturumu başlatılamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source: 'WorkoutLogRemoteDataSource - startWorkoutLog',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<WorkoutSetDto> addSet({
    required int workoutLogId,
    required int exerciseId,
    required int setNumber,
    required int reps,
    required double weight,
  }) async {
    try {
      final response = await _dio
          .post('/workoutlogs/addSetToWorkoutLog/$workoutLogId', data: {
        'exerciseId': exerciseId,
        'setNumber': setNumber,
        'reps': reps,
        'weight': weight,
      });
      final data = response.data as Map<String, dynamic>;
      return WorkoutSetDto.fromJson(data['setLog'] as Map<String, dynamic>);
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source: 'WorkoutLogRemoteDataSource - addSet',
        message: _extractMessage(error) ?? 'Set kaydedilemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source: 'WorkoutLogRemoteDataSource - addSet',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> removeSet({
    required int workoutLogId,
    required int setId,
  }) async {
    try {
      await _dio.delete(
          '/workoutlogs/removeSetFromWorkoutLog/$workoutLogId/$setId');
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source: 'WorkoutLogRemoteDataSource - removeSet',
        message: _extractMessage(error) ?? 'Set silinemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source: 'WorkoutLogRemoteDataSource - removeSet',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] ?? data['error'])?.toString();
    }
    return null;
  }

  Future<List<WorkoutLogDto>>
  getWorkoutLogs() async {
    try {
      final response = await _dio.get(
        '/workoutlogs/getWorkoutLogs',
      );
      final list = response.data as List<dynamic>;
      return list
          .map(
            (json) => WorkoutLogDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WorkoutLogRemoteDataSource - getWorkoutLogs',
        message:
            _extractMessage(error) ??
            'Antrenman geçmişi alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WorkoutLogRemoteDataSource - getWorkoutLogs',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

}