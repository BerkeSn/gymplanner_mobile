// presentation/providers/friend_providers.dart

import 'package:gymplanner_mobile/features/social/data/datasource/friend_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/repositories/friend_repository_impl.dart';
import '../../domain/repositories/friend_repository.dart';

part 'friend_providers.g.dart';

@riverpod
FriendRemoteDataSource friendRemoteDataSource(
  FriendRemoteDataSourceRef ref,
) {
  return FriendRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
FriendRepository friendRepository(
  FriendRepositoryRef ref,
) {
  return FriendRepositoryImpl(
    ref.watch(friendRemoteDataSourceProvider),
  );
}
