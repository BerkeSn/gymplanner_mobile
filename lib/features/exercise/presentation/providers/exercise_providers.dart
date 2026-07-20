// presentation/providers/exercise_providers.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/datasources/exercise_remote_datasource.dart';
import '../../data/repositories/exercise_repository_impl.dart';
import '../../domain/repositories/exercise_repository.dart';

part 'exercise_providers.g.dart';

// Not: Dio istemcisini auth_providers.dart'taki dioProvider'dan tekrar
// kullanıyoruz — her feature kendi Dio örneğini kurmaz, tek bir HTTP
// client tüm interceptor (JWT header) davranışını paylaşır.

@riverpod
ExerciseRemoteDataSource exerciseRemoteDataSource(
  ExerciseRemoteDataSourceRef ref,
) {
  return ExerciseRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
ExerciseRepository exerciseRepository(
  ExerciseRepositoryRef ref,
) {
  return ExerciseRepositoryImpl(
    ref.watch(exerciseRemoteDataSourceProvider),
  );
}
