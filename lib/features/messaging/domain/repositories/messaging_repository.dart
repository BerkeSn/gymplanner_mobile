// repositories/messaging_repository.dart

import 'package:gymplanner_mobile/features/messaging/domain/entites/conversation_entity.dart';
import 'package:gymplanner_mobile/features/messaging/domain/entites/message_entity.dart';

import '../../../../core/error/result.dart';

abstract class MessagingRepository {
  Future<Result<int>> startConversation(
    int friendId,
  );

  Future<Result<List<ConversationEntity>>>
  getConversations();

  Future<Result<List<MessageEntity>>> getMessages(
    int conversationId,
  );

  Future<Result<MessageEntity>> sendMessage({
    required int conversationId,
    required String content,
  });

  Future<Result<void>> markAsRead(
    int conversationId,
  );
}
