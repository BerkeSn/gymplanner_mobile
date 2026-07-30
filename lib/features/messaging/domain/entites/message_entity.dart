// entities/message_entity.dart

class MessageEntity {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderUsername;
  final String content;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderUsername,
    required this.content,
    required this.createdAt,
  });
}
