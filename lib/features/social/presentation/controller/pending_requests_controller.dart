// presentation/controllers/pending_requests_controller.dart

import 'package:gymplanner_mobile/features/social/domain/entites/friendship_request_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/friend_providers.dart';

part 'pending_requests_controller.g.dart';

@Riverpod(keepAlive: true)
class PendingRequestsController
    extends _$PendingRequestsController {
  @override
  FutureOr<List<FriendshipRequestEntity>>
  build() async {
    return _fetch();
  }

  Future<List<FriendshipRequestEntity>>
  _fetch() async {
    try {
      final repository = ref.read(
        friendRepositoryProvider,
      );
      final result = await repository
          .getPendingRequests();
      if (result
          is Failure<
            List<FriendshipRequestEntity>
          >) {
        throw result.exception;
      }
      return (result
              as Success<
                List<FriendshipRequestEntity>
              >)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'PendingRequestsController - _fetch',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> refresh() async {
    state =
        const AsyncLoading<
              List<FriendshipRequestEntity>
            >()
            .copyWithPrevious(state);
    state = await AsyncValue.guard(_fetch);
  }

  Future<bool> respond({
    required int friendshipId,
    required bool accept,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return false;

    // Optimistic: istek listeden anında kaldırılır.
    final optimisticList = current
        .where(
          (r) => r.friendshipId != friendshipId,
        )
        .toList();
    state = AsyncData(optimisticList);

    try {
      final repository = ref.read(
        friendRepositoryProvider,
      );
      final result = await repository
          .respondToRequest(
            friendshipId: friendshipId,
            accept: accept,
          );
      if (result is Failure<void>) {
        throw result.exception;
      }
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'PendingRequestsController - respond',
        error,
        stackTrace,
      );
      state = AsyncData(current); // geri al
      return false;
    }
  }
}
