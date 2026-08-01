// repositories/walk_repository.dart

import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/lat_lng_entity.dart';
import 'package:gymplanner_mobile/features/walk_tracking/domain/entites/walk_session_entity.dart';

import '../../../../core/error/result.dart';

abstract class WalkRepository {
  Future<Result<WalkSessionEntity>> logWalk({
    required DateTime startTime,
    required DateTime endTime,
    required int durationSeconds,
    required double distanceMeters,
    required int steps,
    required int calories,
    required List<LatLngEntity> routePoints,
  });

  Future<Result<List<WalkSessionEntity>>>
  getWalkHistory();

  Future<Result<WalkSessionEntity>> getWalkById(
    int id,
  );
}
