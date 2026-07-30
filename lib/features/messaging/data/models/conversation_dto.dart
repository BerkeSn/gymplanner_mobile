// models/conversation_dto.dart

import 'package:gymplanner_mobile/features/messaging/domain/entites/conversation_entity.dart';

import 'conversation_participant_dto.dart';
import 'message_dto.dart';

class ConversationDto {
  final int id;
  final bool isGroup;
  final String? name;
  final List<ConversationParticipantDto>
  participants;
  final MessageDto? lastMessage;
  final bool isUnread;

  ConversationDto({
    required this.id,
    required this.isGroup,
    this.name,
    required this.participants,
    this.lastMessage,
    required this.isUnread,
  });

  factory ConversationDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final rawParticipants =
          json['participants']
              as List<dynamic>? ??
          [];
      final rawLastMessage =
          json['lastMessage']
              as Map<String, dynamic>?;
      return ConversationDto(
        id: json['id'] as int,
        isGroup:
            json['isGroup'] as bool? ?? false,
        name: json['name'] as String?,
        participants: rawParticipants
            .map(
              (p) =>
                  ConversationParticipantDto.fromJson(
                    p as Map<String, dynamic>,
                  ),
            )
            .toList(),
        lastMessage: rawLastMessage != null
            ? MessageDto.fromJson(rawLastMessage)
            : null,
        isUnread:
            json['isUnread'] as bool? ?? false,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[ConversationDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  ConversationEntity toEntity() =>
      ConversationEntity(
        id: id,
        isGroup: isGroup,
        name: name,
        participants: participants
            .map((p) => p.toEntity())
            .toList(),
        lastMessage: lastMessage?.toEntity(),
        isUnread: isUnread,
      );
}
