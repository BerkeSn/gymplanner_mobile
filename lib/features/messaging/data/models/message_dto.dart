// models/message_dto.dart

import 'package:gymplanner_mobile/features/messaging/domain/entites/message_entity.dart';


class MessageDto {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderUsername;
  final String? content;
  final String createdAt;

  MessageDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderUsername,
    this.content,
    required this.createdAt,
  });

  /// Backend: { id, conversationId, senderId, content, imageUrl, type,
  /// createdAt, sender: {id, username} }
  factory MessageDto.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      final sender =
          json['sender'] as Map<String, dynamic>?;
      return MessageDto(
        id: json['id'] as int,
        conversationId:
            json['conversationId'] as int,
        senderId:
            (sender?['id'] as int?) ??
            json['senderId'] as int,
        senderUsername:
            (sender?['username'] as String?) ??
            '',
        content: json['content'] as String?,
        createdAt: json['createdAt'] as String,
      );
    } catch (error, stackTrace) {
      throw Exception(
        '[MessageDto - fromJson]: ${error.toString()}\n$stackTrace',
      );
    }
  }

  MessageEntity toEntity() => MessageEntity(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    senderUsername: senderUsername,
    content: content ?? '',
    createdAt:
        DateTime.tryParse(createdAt) ??
        DateTime.now(),
  );
}
