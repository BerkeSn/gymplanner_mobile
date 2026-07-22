// presentation/providers/exercise_progress_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/datasources/exercise_progress_remote_datasource.dart';
import '../../data/repositories/exercise_progress_repository_impl.dart';
import '../../domain/repositories/exercise_progress_repository.dart';

part 'exercise_progress_providers.g.dart';

@riverpod
ExerciseProgressRemoteDataSource
exerciseProgressRemoteDataSource(
  ExerciseProgressRemoteDataSourceRef ref,
) {
  return ExerciseProgressRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
ExerciseProgressRepository
exerciseProgressRepository(
  ExerciseProgressRepositoryRef ref,
) {
  return ExerciseProgressRepositoryImpl(
    ref.watch(
      exerciseProgressRemoteDataSourceProvider,
    ),
  );
}
