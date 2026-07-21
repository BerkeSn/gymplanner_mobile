// models/workout_routine_dto.dart

import '../../domain/entities/workout_routine_entity.dart';
import 'routine_exercise_dto.dart';

class WorkoutRoutineDto {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final List<RoutineExerciseDto> routineExercises;

  WorkoutRoutineDto({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    this.routineExercises = const [],
  });

  factory WorkoutRoutineDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final rawExercises =
          json['routineExercises']
              as List<dynamic>? ??
          [];
      return WorkoutRoutineDto(
        id: json['id'] as int,
        name: json['name'] as String,
        description:
            json['description'] as String?,
        isActive:
            json['isActive'] as bool? ?? false,
        routineExercises: rawExercises
            .map(
              (e) => RoutineExerciseDto.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[WorkoutRoutineDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  WorkoutRoutineEntity toEntity() {
    return WorkoutRoutineEntity(
      id: id,
      name: name,
      description: description,
      isActive: isActive,
      routineExercises: routineExercises
          .map((e) => e.toEntity())
          .toList(),
    );
  }
}
