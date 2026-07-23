// repositories/body_measurement_repository.dart

import 'package:gymplanner_mobile/features/body_measurement/domain/entites/body_measurement_entity.dart';
import 'package:gymplanner_mobile/features/body_measurement/domain/entites/measurement_goal.dart';

import '../../../../core/error/result.dart';

abstract class BodyMeasurementRepository {
  Future<Result<List<BodyMeasurementEntity>>>
  getAllMeasurements();

  Future<Result<BodyMeasurementEntity>>
  createMeasurement({
    DateTime? date,
    required double weight,
    required double height,
    double? neck,
    double? waist,
    double? bodyFatPercentage,
    MeasurementGoal? goal,
  });

  Future<Result<void>> deleteMeasurement(int id);
}
