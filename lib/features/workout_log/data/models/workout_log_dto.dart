// features/workout_log/data/models/workout_log_dto.dart — TAMAMEN değiştir

import 'package:gymplanner_mobile/features/workout_log/domain/entites/logged_set_entity.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_log_entity.dart';

class LoggedSetDto {
  final int id;
  final int exerciseId;
  final String? exerciseName;
  final String? exerciseImageUrl;
  final int setNumber;
  final int reps;
  final num weight;

  LoggedSetDto({
    required this.id,
    required this.exerciseId,
    this.exerciseName,
    this.exerciseImageUrl,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });

  /// Backend: workoutSetLogs: [{id, setNumber, reps, weight, exercise: {id,name,imageUrl}}]
  factory LoggedSetDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final exercise =
          json['exercise']
              as Map<String, dynamic>?;
      return LoggedSetDto(
        id: json['id'] as int,
        exerciseId:
            (exercise?['id'] as int?) ??
            json['exerciseId'] as int,
        exerciseName:
            exercise?['name'] as String?,
        exerciseImageUrl:
            exercise?['imageUrl'] as String?,
        setNumber: json['setNumber'] as int,
        reps: json['reps'] as int,
        weight: json['weight'] as num,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[LoggedSetDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  LoggedSetEntity toEntity() => LoggedSetEntity(
    id: id,
    exerciseId: exerciseId,
    exerciseName: exerciseName,
    exerciseImageUrl: exerciseImageUrl,
    setNumber: setNumber,
    reps: reps,
    weight: weight.toDouble(),
  );
}

class WorkoutLogDto {
  final int id;
  final String date;
  final int workoutRoutineId;
  final List<LoggedSetDto> sets; // ⬅️ YENİ

  WorkoutLogDto({
    required this.id,
    required this.date,
    required this.workoutRoutineId,
    this.sets = const [],
  });

  factory WorkoutLogDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final rawSets =
          json['workoutSetLogs']
              as List<dynamic>? ??
          [];
      return WorkoutLogDto(
        id: json['id'] as int,
        date: json['date'] as String,
        workoutRoutineId:
            json['workoutRoutineId'] as int,
        sets: rawSets
            .map(
              (s) => LoggedSetDto.fromJson(
                s as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[WorkoutLogDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  WorkoutLogEntity toEntity() => WorkoutLogEntity(
    id: id,
    date:
        DateTime.tryParse(date) ?? DateTime.now(),
    workoutRoutineId: workoutRoutineId,
    sets: sets.map((s) => s.toEntity()).toList(),
  );
}
