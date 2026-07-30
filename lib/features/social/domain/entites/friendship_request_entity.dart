// entities/friendship_request_entity.dart

import 'user_summary_entity.dart';

class FriendshipRequestEntity {
  final int friendshipId;
  final UserSummaryEntity requester;

  const FriendshipRequestEntity({
    required this.friendshipId,
    required this.requester,
  });
}
