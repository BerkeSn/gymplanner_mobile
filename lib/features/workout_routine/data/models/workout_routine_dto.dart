import '../../domain/entities/training_goal.dart';
import '../../domain/entities/workout_routine_entity.dart';
import 'routine_exercise_dto.dart';

class WorkoutRoutineDto {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final int daysPerWeek;
  final String trainingGoal;
  final List<RoutineExerciseDto> routineExercises;

  WorkoutRoutineDto({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.daysPerWeek,
    required this.trainingGoal,
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
        daysPerWeek:
            json['daysPerWeek'] as int? ?? 3,
        trainingGoal:
            json['trainingGoal'] as String? ??
            'Hypertrophy',
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
      daysPerWeek: daysPerWeek,
      trainingGoal: TrainingGoalX.fromApi(
        trainingGoal,
      ),
      routineExercises: routineExercises
          .map((e) => e.toEntity())
          .toList(),
    );
  }
}
