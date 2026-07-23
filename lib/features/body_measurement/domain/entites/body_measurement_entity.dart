// entities/body_measurement_entity.dart

import 'measurement_goal.dart';

class BodyMeasurementEntity {
  final int id;
  final DateTime date;
  final double weight;
  final double height;
  final double? neck;
  final double? waist;
  final double? bodyFatPercentage;
  final MeasurementGoal goal;

  const BodyMeasurementEntity({
    required this.id,
    required this.date,
    required this.weight,
    required this.height,
    this.neck,
    this.waist,
    this.bodyFatPercentage,
    required this.goal,
  });
}
