import 'package:gymplanner_mobile/features/social/domain/entites/friendship_status.dart';
import 'package:gymplanner_mobile/features/social/domain/entites/public_profile_entity.dart';

import 'user_summary_dto.dart';

class PublicProfileDto {
  final UserSummaryDto user;
  final String friendshipStatus;
  final int? friendshipId;

  PublicProfileDto({
    required this.user,
    required this.friendshipStatus,
    this.friendshipId,
  });

  factory PublicProfileDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      return PublicProfileDto(
        user: UserSummaryDto.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
        friendshipStatus:
            json['friendshipStatus'] as String? ??
            'none',
        friendshipId:
            json['friendshipId'] as int?,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[PublicProfileDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  PublicProfileEntity toEntity() =>
      PublicProfileEntity(
        user: user.toEntity(),
        friendshipStatus:
            FriendshipStatusX.fromApi(
              friendshipStatus,
            ),
        friendshipId: friendshipId,
      );
}
