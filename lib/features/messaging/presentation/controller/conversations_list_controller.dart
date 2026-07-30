// presentation/controllers/conversations_list_controller.dart

import 'package:gymplanner_mobile/features/messaging/domain/entites/conversation_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/socket/socket_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../providers/messaging_providers.dart';

part 'conversations_list_controller.g.dart';

@Riverpod(keepAlive: true)
class ConversationsListController
    extends _$ConversationsListController {
  @override
  FutureOr<List<ConversationEntity>>
  build() async {
    // Yeni mesaj geldiğinde sohbet listesini (sıralama + unread rozeti)
    // güncellemek için soket akışına abone ol.
    final sub = ref
        .read(socketServiceProvider)
        .onNewMessage
        .listen((_) {
          refresh();
        });
    ref.onDispose(sub.cancel);

    return _fetch();
  }

  Future<List<ConversationEntity>>
  _fetch() async {
    try {
      final repository = ref.read(
        messagingRepositoryProvider,
      );
      final result = await repository
          .getConversations();
      if (result
          is Failure<List<ConversationEntity>>) {
        throw result.exception;
      }
      return (result
              as Success<
                List<ConversationEntity>
              >)
          .data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'ConversationsListController - _fetch',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<int?> startConversationWith(
    int friendId,
  ) async {
    try {
      final repository = ref.read(
        messagingRepositoryProvider,
      );
      final result = await repository
          .startConversation(friendId);
      if (result is Failure<int>) {
        throw result.exception;
      }
      await refresh();
      return (result as Success<int>).data;
    } catch (error, stackTrace) {
      AppLogger.error(
        'ConversationsListController - startConversationWith',
        error,
        stackTrace,
      );
      return null;
    }
  }
}
