// repositories/workout_log_repository.dart

import 'package:gymplanner_mobile/features/workout_log/domain/entites/streak_analytics_entity.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_log_entity.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_set_entity.dart';

import '../../../../core/error/result.dart';

abstract class WorkoutLogRepository {

  Future<Result<List<WorkoutLogEntity>>>
  getWorkoutLogs();

  Future<Result<WorkoutLogEntity>>
  startWorkoutLog(int workoutRoutineId);

  Future<Result<StreakAnalyticsEntity>>
  getStreakAnalytics();

  Future<Result<WorkoutSetEntity>> addSet({
    required int workoutLogId,
    required int exerciseId,
    required int setNumber,
    required int reps,
    required double weight,
  });

  Future<Result<void>> removeSet({
    required int workoutLogId,
    required int setId,
  });
}
