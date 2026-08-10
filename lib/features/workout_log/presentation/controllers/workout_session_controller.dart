// features/workout_log/presentation/controllers/workout_session_controller.dart — TAMAMEN değiştir

import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_log_entity.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_set_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/workout_log_providers.dart';

part 'workout_session_controller.g.dart';

class WorkoutSessionState {
  final int workoutLogId;
  final Map<int, List<WorkoutSetEntity>>
  setsByExerciseId;

  const WorkoutSessionState({
    required this.workoutLogId,
    this.setsByExerciseId = const {},
  });

  List<WorkoutSetEntity> setsFor(
    int exerciseId,
  ) => setsByExerciseId[exerciseId] ?? const [];

  WorkoutSessionState copyWith({
    Map<int, List<WorkoutSetEntity>>?
    setsByExerciseId,
  }) {
    return WorkoutSessionState(
      workoutLogId: workoutLogId,
      setsByExerciseId:
          setsByExerciseId ??
          this.setsByExerciseId,
    );
  }
}

@riverpod
class WorkoutSessionController
    extends _$WorkoutSessionController {
  @override
  FutureOr<WorkoutSessionState> build(
    int routineId,
  ) async {
    try {
      final repository = ref.read(
        workoutLogRepositoryProvider,
      );

      // 1) Bugüne, bu programa ait zaten başlamış bir oturum var mı bak.
      final logsResult = await repository
          .getWorkoutLogs();
      if (logsResult
          is Success<List<WorkoutLogEntity>>) {
        final today = DateTime.now();
        final existing = logsResult.data
            .where(
              (log) =>
                  log.workoutRoutineId ==
                      routineId &&
                  log.date.year == today.year &&
                  log.date.month == today.month &&
                  log.date.day == today.day,
            )
            .firstOrNull;

        if (existing != null) {
          final grouped =
              <int, List<WorkoutSetEntity>>{};
          for (final s in existing.sets) {
            grouped
                .putIfAbsent(
                  s.exerciseId,
                  () => [],
                )
                .add(
                  WorkoutSetEntity(
                    id: s.id,
                    workoutLogId: existing.id,
                    exerciseId: s.exerciseId,
                    setNumber: s.setNumber,
                    reps: s.reps,
                    weight: s.weight,
                  ),
                );
          }
          return WorkoutSessionState(
            workoutLogId: existing.id,
            setsByExerciseId: grouped,
          );
        }
      }

      // 2) Yoksa yeni oturum başlat.
      final startResult = await repository
          .startWorkoutLog(routineId);
      if (startResult
          is Failure<WorkoutLogEntity>)
        throw startResult.exception;
      final log =
          (startResult
                  as Success<WorkoutLogEntity>)
              .data;
      return WorkoutSessionState(
        workoutLogId: log.id,
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutSessionController - build',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  // addSet / removeSet metotları AYNEN kalıyor, değişiklik yok.
  Future<bool> addSet({
    required int exerciseId,
    required int setNumber,
    required int reps,
    required double weight,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return false;
    try {
      final repository = ref.read(
        workoutLogRepositoryProvider,
      );
      final result = await repository.addSet(
        workoutLogId: current.workoutLogId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        reps: reps,
        weight: weight,
      );
      if (result is Failure<WorkoutSetEntity>)
        throw result.exception;
      final newSet =
          (result as Success<WorkoutSetEntity>)
              .data;
      final updatedMap =
          Map<int, List<WorkoutSetEntity>>.from(
            current.setsByExerciseId,
          );
      updatedMap[exerciseId] = [
        ...current.setsFor(exerciseId),
        newSet,
      ];
      state = AsyncData(
        current.copyWith(
          setsByExerciseId: updatedMap,
        ),
      );
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutSessionController - addSet',
        error,
        stackTrace,
      );
      return false;
    }
  }

  Future<bool> removeSet({
    required int exerciseId,
    required int setId,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return false;
    try {
      final repository = ref.read(
        workoutLogRepositoryProvider,
      );
      final result = await repository.removeSet(
        workoutLogId: current.workoutLogId,
        setId: setId,
      );
      if (result is Failure<void>)
        throw result.exception;
      final updatedMap =
          Map<int, List<WorkoutSetEntity>>.from(
            current.setsByExerciseId,
          );
      updatedMap[exerciseId] = current
          .setsFor(exerciseId)
          .where((s) => s.id != setId)
          .toList();
      state = AsyncData(
        current.copyWith(
          setsByExerciseId: updatedMap,
        ),
      );
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'WorkoutSessionController - removeSet',
        error,
        stackTrace,
      );
      return false;
    }
  }
}
