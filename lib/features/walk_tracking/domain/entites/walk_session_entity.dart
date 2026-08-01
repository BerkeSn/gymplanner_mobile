// entities/walk_session_entity.dart

import 'lat_lng_entity.dart';

class WalkSessionEntity {
  final int id;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final double distanceMeters;
  final int steps;
  final int calories;
  final List<LatLngEntity> routePoints;

  const WalkSessionEntity({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.steps,
    required this.calories,
    this.routePoints = const [],
  });
}
