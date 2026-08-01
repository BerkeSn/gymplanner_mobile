// datasources/walk_remote_datasource.dart

import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/lat_lng_dto.dart';
import '../models/walk_session_dto.dart';

class WalkRemoteDataSource {
  final Dio _dio;
  const WalkRemoteDataSource(this._dio);

  Future<WalkSessionDto> logWalk({
    required String startTime,
    required String endTime,
    required int durationSeconds,
    required double distanceMeters,
    required int steps,
    required int calories,
    required List<LatLngDto> routePoints,
  }) async {
    try {
      final response = await _dio.post(
        '/walk/logWalk',
        data: {
          'startTime': startTime,
          'endTime': endTime,
          'durationSeconds': durationSeconds,
          'distanceMeters': distanceMeters,
          'steps': steps,
          'calories': calories,
          'routePoints': routePoints
              .map((p) => p.toJson())
              .toList(),
        },
      );
      final data =
          response.data as Map<String, dynamic>;
      return WalkSessionDto.fromJson(
        data['walk'] as Map<String, dynamic>,
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source: 'WalkRemoteDataSource - logWalk',
        message:
            _extractMessage(error) ??
            'Yürüyüş kaydedilemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source: 'WalkRemoteDataSource - logWalk',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<WalkSessionDto>>
  getWalkHistory() async {
    try {
      final response = await _dio.get(
        '/walk/getWalkHistory',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list = data['walks'] as List<dynamic>;
      return list
          .map(
            (json) => WalkSessionDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WalkRemoteDataSource - getWalkHistory',
        message:
            _extractMessage(error) ??
            'Geçmiş alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WalkRemoteDataSource - getWalkHistory',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<WalkSessionDto> getWalkById(
    int id,
  ) async {
    try {
      final response = await _dio.get(
        '/walk/getWalkById/$id',
      );
      final data =
          response.data as Map<String, dynamic>;
      return WalkSessionDto.fromJson(
        data['walk'] as Map<String, dynamic>,
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'WalkRemoteDataSource - getWalkById',
        message:
            _extractMessage(error) ??
            'Yürüyüş alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'WalkRemoteDataSource - getWalkById',
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
