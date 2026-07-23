// models/body_measurement_dto.dart

import 'package:gymplanner_mobile/features/body_measurement/domain/entites/body_measurement_entity.dart';
import 'package:gymplanner_mobile/features/body_measurement/domain/entites/measurement_goal.dart';

class BodyMeasurementDto {
  final int id;
  final String date;
  final num weight;
  final num height;
  final num? neck;
  final num? waist;
  final num? bodyFatPercentage;
  final String goal;

  BodyMeasurementDto({
    required this.id,
    required this.date,
    required this.weight,
    required this.height,
    this.neck,
    this.waist,
    this.bodyFatPercentage,
    required this.goal,
  });

  factory BodyMeasurementDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return BodyMeasurementDto(
        id: json['id'] as int,
        date: json['date'] as String,
        weight: json['weight'] as num,
        height: json['height'] as num,
        neck: json['neck'] as num?,
        waist: json['waist'] as num?,
        bodyFatPercentage:
            json['bodyFatPercentage'] as num?,
        goal:
            json['goal'] as String? ?? 'Maintain',
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[BodyMeasurementDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  BodyMeasurementEntity toEntity() =>
      BodyMeasurementEntity(
        id: id,
        date:
            DateTime.tryParse(date) ??
            DateTime.now(),
        weight: weight.toDouble(),
        height: height.toDouble(),
        neck: neck?.toDouble(),
        waist: waist?.toDouble(),
        bodyFatPercentage: bodyFatPercentage
            ?.toDouble(),
        goal: MeasurementGoalX.fromApi(goal),
      );
}
