class BodyMeasurementEntity {
  final int id;
  final DateTime date;
  final double weight;
  final double height;
  final double? neck;
  final double? waist;
  final double? hip;
  final double? bodyFatPercentage;

  const BodyMeasurementEntity({
    required this.id,
    required this.date,
    required this.weight,
    required this.height,
    this.neck,
    this.waist,
    this.hip,
    this.bodyFatPercentage,
  });
}
