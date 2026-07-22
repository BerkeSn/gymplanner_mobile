import 'routine_exercise_entity.dart';
import 'training_goal.dart';

class WorkoutRoutineEntity {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final int daysPerWeek; // ⬅️ YENİ
  final TrainingGoal trainingGoal; // ⬅️ YENİ
  final List<RoutineExerciseEntity>
  routineExercises;

  const WorkoutRoutineEntity({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.daysPerWeek,
    required this.trainingGoal,
    this.routineExercises = const [],
  });

  WorkoutRoutineEntity copyWith({
    String? name,
    String? description,
    bool? isActive,
    int? daysPerWeek,
    TrainingGoal? trainingGoal,
    List<RoutineExerciseEntity>? routineExercises,
  }) {
    return WorkoutRoutineEntity(
      id: id,
      name: name ?? this.name,
      description:
          description ?? this.description,
      isActive: isActive ?? this.isActive,
      daysPerWeek:
          daysPerWeek ?? this.daysPerWeek,
      trainingGoal:
          trainingGoal ?? this.trainingGoal,
      routineExercises:
          routineExercises ??
          this.routineExercises,
    );
  }
}
