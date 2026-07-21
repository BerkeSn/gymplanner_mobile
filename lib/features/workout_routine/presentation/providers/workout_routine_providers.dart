// presentation/providers/workout_routine_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/datasources/workout_routine_remote_datasource.dart';
import '../../data/repositories/workout_routine_repository_impl.dart';
import '../../domain/repositories/workout_routine_repository.dart';

part 'workout_routine_providers.g.dart';

@riverpod
WorkoutRoutineRemoteDataSource
workoutRoutineRemoteDataSource(
  WorkoutRoutineRemoteDataSourceRef ref,
) {
  return WorkoutRoutineRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
WorkoutRoutineRepository workoutRoutineRepository(
  WorkoutRoutineRepositoryRef ref,
) {
  return WorkoutRoutineRepositoryImpl(
    ref.watch(
      workoutRoutineRemoteDataSourceProvider,
    ),
  );
}
