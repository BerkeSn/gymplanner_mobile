// datasources/exercise_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/exercise_dto.dart';
import '../models/muscle_group_dto.dart';

class ExerciseRemoteDataSource {
  final Dio _dio;
  const ExerciseRemoteDataSource(this._dio);

  // ⚠️ Route path'leri backend'in otomatik lowercase davranışına göre:
  // muscleGroupRoute.js -> /musclegroup, userFavoriteRoute.js -> /userfavorite

  Future<List<MuscleGroupDto>>
  getMuscleGroups() async {
    try {
      final response = await _dio.get(
        '/musclegroup/getAllMuscleGroups',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['muscleGroups'] as List<dynamic>;
      return list
          .map(
            (json) => MuscleGroupDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'ExerciseRemoteDataSource - getMuscleGroups',
        message:
            _extractMessage(error) ??
            'Kas grupları alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'ExerciseRemoteDataSource - getMuscleGroups',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<ExerciseDto>> getExercises({
    int? muscleGroupId,
  }) async {
    try {
      final path = muscleGroupId != null
          ? '/exercise/getExercisesByMuscleGroup/$muscleGroupId'
          : '/exercise/getAllExercises';
      final response = await _dio.get(path);
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['exercises'] as List<dynamic>;
      return list
          .map(
            (json) => ExerciseDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'ExerciseRemoteDataSource - getExercises',
        message:
            _extractMessage(error) ??
            'Egzersizler alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'ExerciseRemoteDataSource - getExercises',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<Set<int>>
  getFavoriteExerciseIds() async {
    try {
      final response = await _dio.get(
        '/userfavorite/getMyFavorites',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['favorites'] as List<dynamic>;
      return list
          .map(
            (json) => (json['exerciseId'] as num)
                .toInt(),
          )
          .toSet();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'ExerciseRemoteDataSource - getFavoriteExerciseIds',
        message:
            _extractMessage(error) ??
            'Favoriler alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'ExerciseRemoteDataSource - getFavoriteExerciseIds',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<bool> toggleFavorite(
    int exerciseId,
  ) async {
    try {
      final response = await _dio.post(
        '/userfavorite/toggleFavorite/$exerciseId',
      );
      final data =
          response.data as Map<String, dynamic>;
      return data['isFavorite'] as bool;
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'ExerciseRemoteDataSource - toggleFavorite',
        message:
            _extractMessage(error) ??
            'Favori işlemi başarısız.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'ExerciseRemoteDataSource - toggleFavorite',
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
