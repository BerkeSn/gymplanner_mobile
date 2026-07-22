// models/workout_set_dto.dart

import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_set_entity.dart';

class WorkoutSetDto {
  final int id;
  final int workoutLogId;
  final int exerciseId;
  final int setNumber;
  final int reps;
  final num weight;

  WorkoutSetDto({
    required this.id,
    required this.workoutLogId,
    required this.exerciseId,
    required this.setNumber,
    required this.reps,
    required this.weight,
  });

  factory WorkoutSetDto.fromJson(Map<String, dynamic> json) {
    try {
      return WorkoutSetDto(
        id: json['id'] as int,
        workoutLogId: json['workoutLogId'] as int,
        exerciseId: json['exerciseId'] as int,
        setNumber: json['setNumber'] as int,
        reps: json['reps'] as int,
        weight: json['weight'] as num,
      );
    } catch (error, stackTrace) {
      throw Exception(
          '[WorkoutSetDto - fromJson]: ${error.toString()}\n$stackTrace');
    }
  }

  WorkoutSetEntity toEntity() => WorkoutSetEntity(
        id: id,
        workoutLogId: workoutLogId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        reps: reps,
        weight: weight.toDouble(),
      );
}