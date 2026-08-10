// features/exercise_progress/domain/entities/exercise_progress_entry.dart — TAMAMEN değiştir

import 'set_detail_entity.dart';

class ExerciseProgressEntry {
  final int workoutLogId;
  final DateTime date;
  final int totalSets;
  final double maxWeight;
  final double totalVolume;
  final double estimated1RM;
  final List<SetDetailEntity> sets; // ⬅️ YENİ

  const ExerciseProgressEntry({
    required this.workoutLogId,
    required this.date,
    required this.totalSets,
    required this.maxWeight,
    required this.totalVolume,
    required this.estimated1RM,
    this.sets = const [],
  });
}
