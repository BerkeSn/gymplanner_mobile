import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/core/error/result.dart';
import 'package:gymplanner_mobile/features/messaging/domain/entites/conversation_entity.dart';
import 'package:gymplanner_mobile/features/messaging/presentation/controller/conversations_list_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../social/presentation/providers/friend_providers.dart';
import 'chat_page.dart';

class MessagesPage
    extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  @override
  ConsumerState<MessagesPage> createState() =>
      _MessagesPageState();
}

class _MessagesPageState
    extends ConsumerState<MessagesPage> {
  int _tabIndex = 0;

  Future<void> _openChatWithFriend(
    int friendId,
  ) async {
    final conversationId = await ref
        .read(
          conversationsListControllerProvider
              .notifier,
        )
        .startConversationWith(friendId);

    if (conversationId != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatPage(
            conversationId: conversationId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentUserId = ref
        .watch(authControllerProvider)
        .valueOrNull
        ?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.messagesTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(l10n.chatsTab),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text(l10n.friendsTab),
                ),
              ],
              selected: {_tabIndex},
              onSelectionChanged: (selected) =>
                  setState(
                    () => _tabIndex =
                        selected.first,
                  ),
            ),
          ),
          Expanded(
            child: _tabIndex == 0
                ? _ChatsTab(
                    currentUserId: currentUserId,
                  )
                : _FriendsTab(
                    onMessageTap:
                        _openChatWithFriend,
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChatsTab extends ConsumerWidget {
  final int? currentUserId;
  const _ChatsTab({required this.currentUserId});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(
      conversationsListControllerProvider,
    );

    return asyncState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) =>
          Center(child: Text('$error')),
      data: (conversations) {
        if (conversations.isEmpty) {
          return Center(
            child: Text(l10n.noConversationsYet),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref
              .read(
                conversationsListControllerProvider
                    .notifier,
              )
              .refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            itemCount: conversations.length,
            separatorBuilder: (_, __) =>
                const SizedBox(
                  height: AppSpacing.sm,
                ),
            itemBuilder: (context, index) {
              final conversation =
                  conversations[index];
              return _ConversationTile(
                conversation: conversation,
                currentUserId: currentUserId ?? 0,
                onTap: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          conversationId:
                              conversation.id,
                        ),
                      ),
                    ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final int currentUserId;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = conversation.displayName(
      currentUserId,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: conversation.isUnread
              ? AppColors.primaryContainer
                    .withValues(alpha: 0.08)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  AppColors.primaryContainer,
              child: Text(
                name.isNotEmpty
                    ? name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: AppColors
                      .onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: conversation.isUnread
                        ? AppTextStyles.bodyLarge
                              .copyWith(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              )
                        : AppTextStyles.bodyLarge,
                  ),
                  if (conversation.lastMessage !=
                      null)
                    Text(
                      conversation
                          .lastMessage!
                          .content,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: AppTextStyles
                          .bodyMedium,
                    ),
                ],
              ),
            ),
            if (conversation.isUnread)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FriendsTab extends ConsumerWidget {
  final ValueChanged<int> onMessageTap;
  const _FriendsTab({required this.onMessageTap});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(
      friendRepositoryProvider,
    );

    return FutureBuilder(
      future: repository.getMyFriends(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final result = snapshot.data;
        final friends = result?.valueOrNull ?? [];

        if (friends.isEmpty) {
          return Center(
            child: Text(l10n.noFriendsYet),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(
            AppSpacing.containerMargin,
          ),
          itemCount: friends.length,
          separatorBuilder: (_, __) =>
              const SizedBox(
                height: AppSpacing.sm,
              ),
          itemBuilder: (context, index) {
            final friend = friends[index];
            return Container(
              padding: const EdgeInsets.all(
                AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors
                    .surfaceContainerLowest,
                borderRadius:
                    BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors
                        .primaryContainer,
                    child: Text(
                      friend
                              .displayName
                              .isNotEmpty
                          ? friend.displayName[0]
                                .toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: AppColors
                            .onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  Expanded(
                    child: Text(
                      friend.displayName,
                      style:
                          AppTextStyles.bodyLarge,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        onMessageTap(friend.id),
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                    ),
                    label: Text(
                      l10n.messageButtonLabel,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
