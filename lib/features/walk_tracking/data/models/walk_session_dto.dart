// models/walk_session_dto.dart

import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/walk_session_entity.dart';

import 'lat_lng_dto.dart';

class WalkSessionDto {
  final int id;
  final String startTime;
  final String? endTime;
  final int durationSeconds;
  final num distanceMeters;
  final int steps;
  final int calories;
  final List<LatLngDto> routePoints;

  WalkSessionDto({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.steps,
    required this.calories,
    this.routePoints = const [],
  });

  factory WalkSessionDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final rawPoints =
          json['routePoints'] as List<dynamic>? ??
          [];
      return WalkSessionDto(
        id: json['id'] as int,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String?,
        durationSeconds:
            json['durationSeconds'] as int,
        distanceMeters:
            json['distanceMeters'] as num? ?? 0,
        steps: json['steps'] as int? ?? 0,
        calories: json['calories'] as int? ?? 0,
        routePoints: rawPoints
            .map(
              (p) => LatLngDto.fromJson(
                p as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[WalkSessionDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  WalkSessionEntity toEntity() =>
      WalkSessionEntity(
        id: id,
        startTime:
            DateTime.tryParse(startTime) ??
            DateTime.now(),
        endTime: endTime != null
            ? DateTime.tryParse(endTime!)
            : null,
        durationSeconds: durationSeconds,
        distanceMeters: distanceMeters.toDouble(),
        steps: steps,
        calories: calories,
        routePoints: routePoints
            .map((p) => p.toEntity())
            .toList(),
      );
}
