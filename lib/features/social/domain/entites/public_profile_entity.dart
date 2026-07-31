import 'friendship_status.dart';
import 'user_summary_entity.dart';

class PublicProfileEntity {
  final UserSummaryEntity user;
  final FriendshipStatus friendshipStatus;
  final int? friendshipId;

  const PublicProfileEntity({
    required this.user,
    required this.friendshipStatus,
    this.friendshipId,
  });
}
