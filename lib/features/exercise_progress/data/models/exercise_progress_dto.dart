// models/exercise_progress_dto.dart

import '../../domain/entities/exercise_progress_entry.dart';

class ExerciseProgressDto {
  final int workoutLogId;
  final String date;
  final int totalSets;
  final num maxWeight;
  final num totalVolume;
  final num estimated1RM;

  ExerciseProgressDto({
    required this.workoutLogId,
    required this.date,
    required this.totalSets,
    required this.maxWeight,
    required this.totalVolume,
    required this.estimated1RM,
  });

  factory ExerciseProgressDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final sets =
          json['sets'] as List<dynamic>? ?? [];
      return ExerciseProgressDto(
        workoutLogId: json['workoutLogId'] as int,
        date: json['date'] as String,
        totalSets: sets.length,
        maxWeight: json['maxWeight'] as num,
        totalVolume: json['totalVolume'] as num,
        estimated1RM: json['estimated1RM'] as num,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[ExerciseProgressDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  ExerciseProgressEntry toEntity() =>
      ExerciseProgressEntry(
        workoutLogId: workoutLogId,
        date:
            DateTime.tryParse(date) ??
            DateTime.now(),
        totalSets: totalSets,
        maxWeight: maxWeight.toDouble(),
        totalVolume: totalVolume.toDouble(),
        estimated1RM: estimated1RM.toDouble(),
      );
}
