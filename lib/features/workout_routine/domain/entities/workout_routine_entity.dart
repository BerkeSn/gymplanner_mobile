// entities/workout_routine_entity.dart

import 'routine_exercise_entity.dart';

class WorkoutRoutineEntity {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final List<RoutineExerciseEntity>
  routineExercises;

  const WorkoutRoutineEntity({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    this.routineExercises = const [],
  });

  WorkoutRoutineEntity copyWith({
    String? name,
    String? description,
    bool? isActive,
    List<RoutineExerciseEntity>? routineExercises,
  }) {
    return WorkoutRoutineEntity(
      id: id,
      name: name ?? this.name,
      description:
          description ?? this.description,
      isActive: isActive ?? this.isActive,
      routineExercises:
          routineExercises ??
          this.routineExercises,
    );
  }
}
