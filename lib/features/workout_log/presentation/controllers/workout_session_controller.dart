// presentation/controllers/workout_session_controller.dart

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

/// family: her (routineId) için bağımsız bir oturum state'i.
/// autoDispose (varsayılan @riverpod) BİLİNÇLİ tercih — kullanıcı antrenman
/// ekranından çıkınca oturum state'i belleğinden silinmeli, bir sonraki
/// girişte YENİ bir startWorkoutLog çağrısı yapılmalı.
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
      final result = await repository
          .startWorkoutLog(routineId);
      if (result is Failure<dynamic>) {
        throw (result as Failure).exception;
      }
      final log = (result as Success).data;
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
      if (result is Failure<WorkoutSetEntity>) {
        throw result.exception;
      }
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
      if (result is Failure<void>) {
        throw result.exception;
      }

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
