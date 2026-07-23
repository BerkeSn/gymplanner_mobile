// repositories/body_measurement_repository_impl.dart

import 'package:gymplanner_mobile/features/body_measurement/data/datasource/body_measurement_remote_datasource.dart';
import 'package:gymplanner_mobile/features/body_measurement/domain/entites/body_measurement_entity.dart';
import 'package:gymplanner_mobile/features/body_measurement/domain/entites/measurement_goal.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/body_measurement_repository.dart';

class BodyMeasurementRepositoryImpl
    implements BodyMeasurementRepository {
  final BodyMeasurementRemoteDataSource
  _remoteDataSource;
  const BodyMeasurementRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<List<BodyMeasurementEntity>>>
  getAllMeasurements() async {
    try {
      final dtos = await _remoteDataSource
          .getAllMeasurements();
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
              'BodyMeasurementRepositoryImpl - getAllMeasurements',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<BodyMeasurementEntity>>
  createMeasurement({
    DateTime? date,
    required double weight,
    required double height,
    double? neck,
    double? waist,
    double? bodyFatPercentage,
    MeasurementGoal? goal,
  }) async {
    try {
      final dto = await _remoteDataSource
          .createMeasurement(
            date: date
                ?.toIso8601String()
                .split('T')
                .first,
            weight: weight,
            height: height,
            neck: neck,
            waist: waist,
            bodyFatPercentage: bodyFatPercentage,
            goal: goal?.apiValue,
          );
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'BodyMeasurementRepositoryImpl - createMeasurement',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteMeasurement(
    int id,
  ) async {
    try {
      await _remoteDataSource.deleteMeasurement(
        id,
      );
      return const Success(null);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'BodyMeasurementRepositoryImpl - deleteMeasurement',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
