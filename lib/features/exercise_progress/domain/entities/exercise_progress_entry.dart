// entities/exercise_progress_entry.dart

class ExerciseProgressEntry {
  final int workoutLogId;
  final DateTime date;
  final int totalSets;
  final double maxWeight;
  final double totalVolume;
  final double estimated1RM;

  const ExerciseProgressEntry({
    required this.workoutLogId,
    required this.date,
    required this.totalSets,
    required this.maxWeight,
    required this.totalVolume,
    required this.estimated1RM,
  });
}
