// presentation/providers/messaging_providers.dart

import 'package:gymplanner_mobile/features/messaging/data/datasource/messaging_remote_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart'
    show dioProvider;
import '../../data/repositories/messaging_repository_impl.dart';
import '../../domain/repositories/messaging_repository.dart';

part 'messaging_providers.g.dart';

@riverpod
MessagingRemoteDataSource
messagingRemoteDataSource(
  MessagingRemoteDataSourceRef ref,
) {
  return MessagingRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
MessagingRepository messagingRepository(
  MessagingRepositoryRef ref,
) {
  return MessagingRepositoryImpl(
    ref.watch(messagingRemoteDataSourceProvider),
  );
}
