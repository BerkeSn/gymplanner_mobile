import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/body_measurement_dto.dart';

class BodyMeasurementRemoteDataSource {
  final Dio _dio;
  const BodyMeasurementRemoteDataSource(
    this._dio,
  );

  Future<List<BodyMeasurementDto>>
  getAllMeasurements() async {
    try {
      final response = await _dio.get(
        '/bodymeasurement/getAllBodyMeasurements',
      );
      final data =
          response.data as Map<String, dynamic>;
      final list =
          data['bodyMeasurements']
              as List<dynamic>;
      return list
          .map(
            (json) => BodyMeasurementDto.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'BodyMeasurementRemoteDataSource - getAllMeasurements',
        message:
            _extractMessage(error) ??
            'Ölçümler alınamadı.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'BodyMeasurementRemoteDataSource - getAllMeasurements',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<BodyMeasurementDto> createMeasurement({
    String? date,
    required double weight,
    required double height,
    double? neck,
    double? waist,
    double? hip,
    double? bodyFatPercentage,
  }) async {
    try {
      final response = await _dio.post(
        '/bodymeasurement/createMeasurement',
        data: {
          if (date != null) 'date': date,
          'weight': weight,
          'height': height,
          if (neck != null) 'neck': neck,
          if (waist != null) 'waist': waist,
          if (hip != null) 'hip': hip,
          if (bodyFatPercentage != null)
            'bodyFatPercentage':
                bodyFatPercentage,
        },
      );
      final data =
          response.data as Map<String, dynamic>;
      return BodyMeasurementDto.fromJson(
        data['measurement']
            as Map<String, dynamic>,
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'BodyMeasurementRemoteDataSource - createMeasurement',
        message:
            _extractMessage(error) ??
            'Ölçüm kaydedilemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'BodyMeasurementRemoteDataSource - createMeasurement',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// ⚠️ Backend route'u POST (PUT değil): router.post('/updateMeasurement/:id', ...)
  Future<void> updateMeasurement({
    required int id,
    String? date,
    double? weight,
    double? height,
    double? neck,
    double? waist,
    double? hip,
    double? bodyFatPercentage,
  }) async {
    try {
      await _dio.post(
        '/bodymeasurement/updateMeasurement/$id',
        data: {
          if (date != null) 'date': date,
          if (weight != null) 'weight': weight,
          if (height != null) 'height': height,
          if (neck != null) 'neck': neck,
          if (waist != null) 'waist': waist,
          if (hip != null) 'hip': hip,
          if (bodyFatPercentage != null)
            'bodyFatPercentage':
                bodyFatPercentage,
        },
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'BodyMeasurementRemoteDataSource - updateMeasurement',
        message:
            _extractMessage(error) ??
            'Ölçüm güncellenemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'BodyMeasurementRemoteDataSource - updateMeasurement',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// ⚠️ Backend route'u PUT — router.put('/deleteMeasurement/:id', ...) (tuhaf ama böyle)
  Future<void> deleteMeasurement(int id) async {
    try {
      await _dio.put(
        '/bodymeasurement/deleteMeasurement/$id',
      );
    } on DioException catch (error, stackTrace) {
      throw AppExceptionFactory.network(
        source:
            'BodyMeasurementRemoteDataSource - deleteMeasurement',
        message:
            _extractMessage(error) ??
            'Ölçüm silinemedi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      throw AppExceptionFactory.unexpected(
        source:
            'BodyMeasurementRemoteDataSource - deleteMeasurement',
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
