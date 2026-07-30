// presentation/controllers/chat_controller.dart

import 'package:gymplanner_mobile/features/messaging/domain/entites/message_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/socket/socket_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/messaging_providers.dart';
import 'conversations_list_controller.dart';

part 'chat_controller.g.dart';

/// family: her conversationId için bağımsız state, autoDispose (varsayılan
/// @riverpod) — sohbet ekranından çıkınca bellekten temizlenir.
@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<List<MessageEntity>> build(
    int conversationId,
  ) async {
    final sub = ref
        .read(socketServiceProvider)
        .onNewMessage
        .listen((data) {
          try {
            final incomingConversationId =
                data['conversationId'] as int?;
            if (incomingConversationId !=
                conversationId)
              return;

            final messageJson =
                data['message']
                    as Map<String, dynamic>?;
            if (messageJson == null) return;

            final sender =
                messageJson['sender']
                    as Map<String, dynamic>?;
            final newMessage = MessageEntity(
              id: messageJson['id'] as int,
              conversationId: conversationId,
              senderId:
                  (sender?['id'] as int?) ?? 0,
              senderUsername:
                  (sender?['username']
                      as String?) ??
                  '',
              content:
                  messageJson['content']
                      as String? ??
                  '',
              createdAt:
                  DateTime.tryParse(
                    messageJson['createdAt']
                            as String? ??
                        '',
                  ) ??
                  DateTime.now(),
            );

            final current =
                state.valueOrNull ?? [];
            // Aynı mesajı iki kez eklememek için ID kontrolü (kendi gönderdiğin
            // mesaj hem REST cevabından hem socket'ten gelebilir).
            if (current.any(
              (m) => m.id == newMessage.id,
            ))
              return;
            state = AsyncData([
              ...current,
              newMessage,
            ]);
          } catch (error, stackTrace) {
            AppLogger.error(
              'ChatController - socket listener',
              error,
              stackTrace,
            );
          }
        });
    ref.onDispose(sub.cancel);

    try {
      final repository = ref.read(
        messagingRepositoryProvider,
      );
      await repository.markAsRead(conversationId);

      final result = await repository.getMessages(
        conversationId,
      );
      if (result
          is Failure<List<MessageEntity>>) {
        throw result.exception;
      }
      return (result
              as Success<List<MessageEntity>>)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'ChatController - build',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> sendMessage(String content) async {
    if (content.trim().isEmpty) return false;
    try {
      final repository = ref.read(
        messagingRepositoryProvider,
      );
      final result = await repository.sendMessage(
        conversationId: conversationId,
        content: content.trim(),
      );
      if (result is Failure<MessageEntity>) {
        throw result.exception;
      }

      final newMessage =
          (result as Success<MessageEntity>).data;
      final current = state.valueOrNull ?? [];
      if (!current.any(
        (m) => m.id == newMessage.id,
      )) {
        state = AsyncData([
          ...current,
          newMessage,
        ]);
      }

      // Sohbet listesindeki "son mesaj" önizlemesini de tazele.
      ref
          .read(
            conversationsListControllerProvider
                .notifier,
          )
          .refresh();
      return true;
    } catch (error, stackTrace) {
      AppLogger.error(
        'ChatController - sendMessage',
        error,
        stackTrace,
      );
      return false;
    }
  }
}
