// features/exercise_progress/data/models/exercise_progress_dto.dart — TAMAMEN değiştir

import '../../domain/entities/exercise_progress_entry.dart';
import '../../domain/entities/set_detail_entity.dart';

class SetDetailDto {
  final int id;
  final int setNumber;
  final num reps;
  final num weight;
  SetDetailDto({
    required this.id,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });

  factory SetDetailDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SetDetailDto(
      id: json['id'] as int,
      setNumber: json['setNumber'] as int,
      reps: json['reps'] as num,
      weight: json['weight'] as num,
    );
  }

  SetDetailEntity toEntity() => SetDetailEntity(
    id: id,
    setNumber: setNumber,
    reps: reps.toInt(),
    weight: weight.toDouble(),
  );
}

class ExerciseProgressDto {
  final int workoutLogId;
  final String date;
  final num maxWeight;
  final num totalVolume;
  final num estimated1RM;
  final List<SetDetailDto> sets; // ⬅️ YENİ

  ExerciseProgressDto({
    required this.workoutLogId,
    required this.date,
    required this.maxWeight,
    required this.totalVolume,
    required this.estimated1RM,
    required this.sets,
  });

  factory ExerciseProgressDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final rawSets =
          json['sets'] as List<dynamic>? ?? [];
      return ExerciseProgressDto(
        workoutLogId: json['workoutLogId'] as int,
        date: json['date'] as String,
        maxWeight: json['maxWeight'] as num,
        totalVolume: json['totalVolume'] as num,
        estimated1RM: json['estimated1RM'] as num,
        sets: rawSets
            .map(
              (s) => SetDetailDto.fromJson(
                s as Map<String, dynamic>,
              ),
            )
            .toList(),
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
        totalSets: sets.length,
        maxWeight: maxWeight.toDouble(),
        totalVolume: totalVolume.toDouble(),
        estimated1RM: estimated1RM.toDouble(),
        sets: sets
            .map((s) => s.toEntity())
            .toList(),
      );
}
