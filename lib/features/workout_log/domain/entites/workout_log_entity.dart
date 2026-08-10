// features/workout_log/domain/entities/workout_log_entity.dart — TAMAMEN değiştir

import 'logged_set_entity.dart';

class WorkoutLogEntity {
  final int id;
  final DateTime date;
  final int workoutRoutineId;
  final List<LoggedSetEntity> sets; // ⬅️ YENİ

  const WorkoutLogEntity({
    required this.id,
    required this.date,
    required this.workoutRoutineId,
    this.sets = const [],
  });

  List<LoggedSetEntity> setsForExercise(
    int exerciseId,
  ) => sets
      .where((s) => s.exerciseId == exerciseId)
      .toList();
}
