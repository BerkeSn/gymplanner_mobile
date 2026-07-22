// datasources/exercise_progress_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/exercise_progress_dto.dart';

class ExerciseProgressRemoteDataSource {
  final Dio _dio;
  const ExerciseProgressRemoteDataSource(
    this._dio,
  );

  Future<List<ExerciseProgressDto>> getProgress(
    int exerciseId,
  ) async {
    try {
      final response = await _dio.get(
        '/workoutlogs/getExerciseProgress/$exerciseId',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['history'] as List<dynamic>;
      return list
          .map(
            (json) =>
                ExerciseProgressDto.fromJson(
                  json as Map<String, dynamic>,
                ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'ExerciseProgressRemoteDataSource - getProgress',
        message:
            _extractMessage(error) ??
            'İlerleme verisi alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'ExerciseProgressRemoteDataSource - getProgress',
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
