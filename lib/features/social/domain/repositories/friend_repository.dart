// repositories/friend_repository.dart

import 'package:gymplanner_mobile/features/social/domain/entites/friendship_request_entity.dart';
import 'package:gymplanner_mobile/features/social/domain/entites/public_profile_entity.dart';
import 'package:gymplanner_mobile/features/social/domain/entites/user_summary_entity.dart';

import '../../../../core/error/result.dart';

abstract class FriendRepository {
  /// Backend en az 2 karakter istiyor, çağıran taraf bunu garanti etmeli.
  Future<Result<List<UserSummaryEntity>>>
  searchUsers(String query);
  Future<Result<PublicProfileEntity>>
  getPublicProfile(int userId);

  Future<Result<void>> sendFriendRequest(
    int receiverId,
  );

  Future<Result<List<FriendshipRequestEntity>>>
  getPendingRequests();

  Future<Result<void>> respondToRequest({
    required int friendshipId,
    required bool accept,
  });

  Future<Result<List<UserSummaryEntity>>>
  getMyFriends();
}
