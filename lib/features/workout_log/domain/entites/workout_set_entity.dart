// entities/workout_set_entity.dart

class WorkoutSetEntity {
  final int id;
  final int workoutLogId;
  final int exerciseId;
  final int setNumber;
  final int reps;
  final double weight;

  const WorkoutSetEntity({
    required this.id,
    required this.workoutLogId,
    required this.exerciseId,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });
}
