// presentation/providers/workout_log_providers.dart

import 'package:gymplanner_mobile/core/error/result.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/workout_log_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/datasources/workout_log_remote_datasource.dart';
import '../../data/repositories/workout_log_repository_impl.dart';
import '../../domain/repositories/workout_log_repository.dart';

part 'workout_log_providers.g.dart';

@riverpod
WorkoutLogRemoteDataSource
workoutLogRemoteDataSource(
  WorkoutLogRemoteDataSourceRef ref,
) {
  return WorkoutLogRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
WorkoutLogRepository workoutLogRepository(
  WorkoutLogRepositoryRef ref,
) {
  return WorkoutLogRepositoryImpl(
    ref.watch(workoutLogRemoteDataSourceProvider),
  );
}

@riverpod
Future<int> completedWorkoutCount(
  CompletedWorkoutCountRef ref,
) async {
  try {
    final repository = ref.read(
      workoutLogRepositoryProvider,
    );
    final result = await repository
        .getWorkoutLogs();
    if (result
        is Failure<List<WorkoutLogEntity>>) {
      // ⬅️ DÜZELTİ: List<dynamic> değil, List<WorkoutLogEntity>
      throw result.exception;
    }
    return (result
            as Success<List<WorkoutLogEntity>>)
        .data
        .length; // ⬅️ DÜZELTİ: aynı sebepten
  } catch (error, stackTrace) {
    return 0;
  }
}
