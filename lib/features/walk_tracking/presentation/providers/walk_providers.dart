// presentation/providers/walk_providers.dart

import 'package:gymplanner_mobile/features/walk_tracking/data/datasource/walk_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/repositories/walk_repository_impl.dart';
import '../../domain/repositories/walk_repository.dart';

part 'walk_providers.g.dart';

@riverpod
WalkRemoteDataSource walkRemoteDataSource(
  WalkRemoteDataSourceRef ref,
) {
  return WalkRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
WalkRepository walkRepository(
  WalkRepositoryRef ref,
) {
  return WalkRepositoryImpl(
    ref.watch(walkRemoteDataSourceProvider),
  );
}
