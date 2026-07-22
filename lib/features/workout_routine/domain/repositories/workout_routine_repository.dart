// repositories/workout_routine_repository.dart

import 'package:gymplanner_mobile/features/workout_routine/domain/entities/workout_routine_entity.dart';

import '../../../../core/error/result.dart';
import '../entities/training_goal.dart';
import '../entities/week_day.dart';

abstract class WorkoutRoutineRepository {
  Future<Result<List<WorkoutRoutineEntity>>>
  getWorkoutRoutines();

Future<Result<WorkoutRoutineEntity>>
  createWorkoutRoutine({
    required String name,
    String? description,
    required int daysPerWeek, // ⬅️ YENİ
    required TrainingGoal trainingGoal, // ⬅️ YENİ
  });

Future<Result<void>> updateWorkoutRoutine({
  required int id,
  String? name,
  String? description,
  bool? isActive,
  int? daysPerWeek,                // ⬅️ YENİ
  TrainingGoal? trainingGoal,      // ⬅️ YENİ
});

  Future<Result<void>> deleteWorkoutRoutine(
    int id,
  );

  /// Başarılıysa backend'in ürettiği yeni RoutineExercise ID'sini döner.
  /// Egzersizin adı/görseli zaten seçim ekranında elimizde olduğu için
  /// backend'den tekrar sorgulamaya gerek yok — controller entity'yi
  /// lokal olarak kurar.
  Future<Result<int>> addExerciseToRoutine({
    required int routineId,
    required int exerciseId,
    required WeekDay day,
    required int targetSets,
    required int targetReps,
  });

  Future<Result<void>> deleteRoutineExercise(
    int routineExerciseId,
  );
}
