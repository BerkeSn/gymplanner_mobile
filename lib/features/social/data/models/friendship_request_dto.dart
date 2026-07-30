// models/friendship_request_dto.dart

import 'package:gymplanner_mobile/features/social/domain/entites/friendship_request_entity.dart';

import 'user_summary_dto.dart';

class FriendshipRequestDto {
  final int friendshipId;
  final UserSummaryDto requester;

  FriendshipRequestDto({
    required this.friendshipId,
    required this.requester,
  });

  /// Backend: { id, requesterId, receiverId, status, requester: {id, username} }
  factory FriendshipRequestDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return FriendshipRequestDto(
        friendshipId: json['id'] as int,
        requester: UserSummaryDto.fromJson(
          json['requester']
              as Map<String, dynamic>,
        ),
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[FriendshipRequestDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  FriendshipRequestEntity toEntity() =>
      FriendshipRequestEntity(
        friendshipId: friendshipId,
        requester: requester.toEntity(),
      );
}
