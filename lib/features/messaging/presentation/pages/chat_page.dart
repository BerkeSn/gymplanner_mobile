import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/messaging/presentation/controller/chat_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ChatPage extends ConsumerStatefulWidget {
  final int conversationId;
  const ChatPage({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatPage> createState() =>
      _ChatPageState();
}

class _ChatPageState
    extends ConsumerState<ChatPage> {
  final _messageController =
      TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future<void> _handleSend() async {
    final text = _messageController.text;
    if (text.trim().isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      final success = await ref
          .read(
            chatControllerProvider(
              widget.conversationId,
            ).notifier,
          )
          .sendMessage(text);
      if (success) {
        _messageController.clear();
        WidgetsBinding.instance
            .addPostFrameCallback(
              (_) => _scrollToBottom(),
            );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'ChatPage - _handleSend',
        error,
        stackTrace,
      );
    } finally {
      if (mounted)
        setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUserId =
        ref
            .watch(authControllerProvider)
            .valueOrNull
            ?.id ??
        0;
    final asyncMessages = ref.watch(
      chatControllerProvider(
        widget.conversationId,
      ),
    );

    ref.listen(
      chatControllerProvider(
        widget.conversationId,
      ),
      (previous, next) {
        if (previous?.valueOrNull?.length !=
            next.valueOrNull?.length) {
          WidgetsBinding.instance
              .addPostFrameCallback(
                (_) => _scrollToBottom(),
              );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Sohbet')),
      body: Column(
        children: [
          Expanded(
            child: asyncMessages.when(
              loading: () => const Center(
                child:
                    CircularProgressIndicator(),
              ),
              error: (error, _) =>
                  Center(child: Text('$error')),
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noMessagesYet,
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(
                    AppSpacing.containerMargin,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index];
                    final isMine =
                        message.senderId ==
                        currentUserId;
                    return _MessageBubble(
                      content: message.content,
                      isMine: isMine,
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(
                AppSpacing.containerMargin,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller:
                          _messageController,
                      decoration: InputDecoration(
                        hintText:
                            l10n.typeMessageHint,
                        filled: true,
                      ),
                      onSubmitted: (_) =>
                          _handleSend(),
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.sm,
                  ),
                  IconButton.filled(
                    onPressed: _isSending
                        ? null
                        : _handleSend,
                    icon: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String content;
  final bool isMine;
  const _MessageBubble({
    required this.content,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: AppSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width *
              0.75,
        ),
        decoration: BoxDecoration(
          color: isMine
              ? AppColors.primary
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          content,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isMine
                ? AppColors.onPrimary
                : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
