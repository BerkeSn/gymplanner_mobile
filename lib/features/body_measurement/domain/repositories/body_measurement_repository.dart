import 'package:gymplanner_mobile/features/body_measurement/domain/entites/body_measurement_entity.dart';

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
    double? hip,
    double? bodyFatPercentage,
  });

  // ⬇️ YENİ
  Future<Result<void>> updateMeasurement({
    required int id,
    DateTime? date,
    double? weight,
    double? height,
    double? neck,
    double? waist,
    double? hip,
    double? bodyFatPercentage,
  });

  Future<Result<void>> deleteMeasurement(int id);
}
