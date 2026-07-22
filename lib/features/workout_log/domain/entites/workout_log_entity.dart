// entities/workout_log_entity.dart

class WorkoutLogEntity {
  final int id;
  final DateTime date;
  final int workoutRoutineId;

  const WorkoutLogEntity({
    required this.id,
    required this.date,
    required this.workoutRoutineId,
  });
}
