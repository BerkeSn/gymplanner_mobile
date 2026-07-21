// models/routine_exercise_dto.dart

import '../../domain/entities/routine_exercise_entity.dart';
import '../../domain/entities/week_day.dart';

class RoutineExerciseDto {
  final int id;
  final String day;
  final int targetSets;
  final int targetReps;
  final int? exerciseId;
  final String? exerciseName;
  final String? exerciseImageUrl;

  RoutineExerciseDto({
    required this.id,
    required this.day,
    required this.targetSets,
    required this.targetReps,
    this.exerciseId,
    this.exerciseName,
    this.exerciseImageUrl,
  });

  /// getWorkoutRoutines/getWorkoutRoutineById nested 'exercise' objesiyle
  /// gelir: { id, day, targetSets, targetReps, exerciseId, exercise: {id,name,imageUrl} }
  factory RoutineExerciseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final exercise =
          json['exercise']
              as Map<String, dynamic>?;
      return RoutineExerciseDto(
        id: json['id'] as int,
        day: json['day'] as String,
        targetSets: json['targetSets'] as int,
        targetReps: json['targetReps'] as int,
        exerciseId:
            exercise?['id'] as int? ??
            json['exerciseId'] as int?,
        exerciseName:
            exercise?['name'] as String?,
        exerciseImageUrl:
            exercise?['imageUrl'] as String?,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[RoutineExerciseDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  RoutineExerciseEntity toEntity() {
    return RoutineExerciseEntity(
      id: id,
      day: WeekDayX.fromApi(day),
      targetSets: targetSets,
      targetReps: targetReps,
      exerciseId: exerciseId ?? 0,
      exerciseName:
          exerciseName ?? 'Bilinmeyen Hareket',
      exerciseImageUrl: exerciseImageUrl,
    );
  }
}
