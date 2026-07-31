// presentation/controllers/public_profile_controller.dart (yeni dosya)

import 'package:gymplanner_mobile/features/social/domain/entites/public_profile_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/friend_providers.dart';

part 'public_profile_controller.g.dart';

/// family: her userId için bağımsız state. autoDispose (varsayılan
/// @riverpod) — bu bir detay ekranı, çıkınca bellekten temizlenmeli.
@riverpod
class PublicProfileController
    extends _$PublicProfileController {
  @override
  FutureOr<PublicProfileEntity> build(
    int userId,
  ) async {
    return _fetch(userId);
  }

  Future<PublicProfileEntity> _fetch(
    int userId,
  ) async {
    try {
      final repository = ref.read(
        friendRepositoryProvider,
      );
      final result = await repository
          .getPublicProfile(userId);
      if (result
          is Failure<PublicProfileEntity>) {
        throw result.exception;
      }
      return (result
              as Success<PublicProfileEntity>)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'PublicProfileController - _fetch',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => _fetch(userId),
    );
  }

  Future<bool> sendRequest() async {
    try {
      final repository = ref.read(
        friendRepositoryProvider,
      );
      final result = await repository
          .sendFriendRequest(userId);
      if (result is Failure<void>) {
        throw result.exception;
      }
      await refresh();
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'PublicProfileController - sendRequest',
        error,
        stackTrace,
      );
      return false;
    }
  }

  Future<bool> respondToRequest({
    required bool accept,
  }) async {
    final current = state.valueOrNull;
    if (current?.friendshipId == null)
      return false;

    try {
      final repository = ref.read(
        friendRepositoryProvider,
      );
      final result = await repository
          .respondToRequest(
            friendshipId: current!.friendshipId!,
            accept: accept,
          );
      if (result is Failure<void>) {
        throw result.exception;
      }
      await refresh();
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'PublicProfileController - respondToRequest',
        error,
        stackTrace,
      );
      return false;
    }
  }
}
