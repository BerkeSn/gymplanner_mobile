// presentation/providers/profile_providers.dart

import 'package:gymplanner_mobile/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_providers.g.dart';

@riverpod
ProfileRemoteDataSource profileRemoteDataSource(
  ProfileRemoteDataSourceRef ref,
) {
  return ProfileRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
ProfileRepository profileRepository(
  ProfileRepositoryRef ref,
) {
  return ProfileRepositoryImpl(
    ref.watch(profileRemoteDataSourceProvider),
  );
}
