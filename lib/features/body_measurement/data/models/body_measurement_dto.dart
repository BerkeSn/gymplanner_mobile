import 'package:gymplanner_mobile/features/body_measurement/domain/entites/body_measurement_entity.dart';

class BodyMeasurementDto {
  final int id;
  final String date;
  final num weight;
  final num height;
  final num? neck;
  final num? waist;
  final num? hip;
  final num? bodyFatPercentage;

  BodyMeasurementDto({
    required this.id,
    required this.date,
    required this.weight,
    required this.height,
    this.neck,
    this.waist,
    this.hip,
    this.bodyFatPercentage,
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
        hip: json['hip'] as num?,
        bodyFatPercentage:
            json['bodyFatPercentage'] as num?,
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
        hip: hip?.toDouble(),
        bodyFatPercentage: bodyFatPercentage
            ?.toDouble(),
      );
}
