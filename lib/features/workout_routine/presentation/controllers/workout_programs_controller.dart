// presentation/controllers/workout_programs_controller.dart

import 'package:gymplanner_mobile/features/workout_routine/domain/entities/training_goal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/week_day.dart';
import '../../domain/entities/workout_routine_entity.dart';
import '../providers/workout_routine_providers.dart';

part 'workout_programs_controller.g.dart';

@Riverpod(keepAlive: true)
class WorkoutProgramsController
    extends _$WorkoutProgramsController {
  @override
  FutureOr<List<WorkoutRoutineEntity>>
  build() async {
    return _fetch();
  }

  Future<List<WorkoutRoutineEntity>>
  _fetch() async {
    try {
      final repository = ref.read(
        workoutRoutineRepositoryProvider,
      );
      final result = await repository
          .getWorkoutRoutines();
      if (result
          is Failure<
            List<WorkoutRoutineEntity>
          >) {
        throw result.exception;
      }
      return (result
              as Success<
                List<WorkoutRoutineEntity>
              >)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutProgramsController - _fetch',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> refresh() async {
    state =
        const AsyncLoading<
              List<WorkoutRoutineEntity>
            >()
            .copyWithPrevious(state);
    state = await AsyncValue.guard(_fetch);
  }

  /// Yeni program oluşturur ve döndürür (çağıran taraf, örn. detay sheet'i
  /// açmak için ID'ye ihtiyaç duyabilir).
  Future<WorkoutRoutineEntity?> createProgram({
    required String name,
    String? description,
    required int daysPerWeek, // ⬅️ YENİ
    required TrainingGoal trainingGoal, // ⬅️ YENİ
  }) async {
    try {
      final repository = ref.read(
        workoutRoutineRepositoryProvider,
      );
      final result = await repository
          .createWorkoutRoutine(
            name: name,
            description: description,
            daysPerWeek: daysPerWeek,
            trainingGoal: trainingGoal,
          );
      if (result
          is Failure<WorkoutRoutineEntity>) {
        throw result.exception;
      }
      final created =
          (result
                  as Success<
                    WorkoutRoutineEntity
                  >)
              .data;
      await refresh();
      return created;
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutProgramsController - createProgram',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> toggleActive(
    WorkoutRoutineEntity routine,
  ) async {
    final current = state.valueOrNull;
    if (current == null) return;

    // Optimistic update.
    final optimisticList = current
        .map(
          (r) => r.id == routine.id
              ? r.copyWith(isActive: !r.isActive)
              : r,
        )
        .toList();
    state = AsyncData(optimisticList);

    try {
      final repository = ref.read(
        workoutRoutineRepositoryProvider,
      );
      final result = await repository
          .updateWorkoutRoutine(
            id: routine.id,
            isActive: !routine.isActive,
          );
      if (result is Failure<void>) {
        throw result.exception;
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutProgramsController - toggleActive',
        error,
        stackTrace,
      );
      state = AsyncData(current); // geri al
    }
  }

  Future<void> deleteProgram(
    int routineId,
  ) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final optimisticList = current
        .where((r) => r.id != routineId)
        .toList();
    state = AsyncData(optimisticList);

    try {
      final repository = ref.read(
        workoutRoutineRepositoryProvider,
      );
      final result = await repository
          .deleteWorkoutRoutine(routineId);
      if (result is Failure<void>) {
        throw result.exception;
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutProgramsController - deleteProgram',
        error,
        stackTrace,
      );
      state = AsyncData(current); // geri al
    }
  }

  Future<void> addExerciseToRoutine({
    required int routineId,
    required int exerciseId,
    required String exerciseName,
    String? exerciseImageUrl,
    required WeekDay day,
    required int targetSets,
    required int targetReps,
  }) async {
    try {
      final repository = ref.read(
        workoutRoutineRepositoryProvider,
      );
      final result = await repository
          .addExerciseToRoutine(
            routineId: routineId,
            exerciseId: exerciseId,
            day: day,
            targetSets: targetSets,
            targetReps: targetReps,
          );
      if (result is Failure<int>) {
        throw result.exception;
      }
      await refresh();
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutProgramsController - addExerciseToRoutine',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> removeRoutineExercise(
    int routineExerciseId,
  ) async {
    try {
      final repository = ref.read(
        workoutRoutineRepositoryProvider,
      );
      final result = await repository
          .deleteRoutineExercise(
            routineExerciseId,
          );
      if (result is Failure<void>) {
        throw result.exception;
      }
      await refresh();
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutProgramsController - removeRoutineExercise',
        error,
        stackTrace,
      );
      rethrow;
    }
  }
}
