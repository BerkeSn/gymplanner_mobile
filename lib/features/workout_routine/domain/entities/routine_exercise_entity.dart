// entities/routine_exercise_entity.dart

import 'week_day.dart';

class RoutineExerciseEntity {
  final int id;
  final WeekDay day;
  final int targetSets;
  final int targetReps;
  final int exerciseId;
  final String exerciseName;
  final String? exerciseImageUrl;

  const RoutineExerciseEntity({
    required this.id,
    required this.day,
    required this.targetSets,
    required this.targetReps,
    required this.exerciseId,
    required this.exerciseName,
    this.exerciseImageUrl,
  });
}
