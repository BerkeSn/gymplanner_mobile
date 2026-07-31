import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/messaging/presentation/controller/conversations_list_controller.dart';
import 'package:gymplanner_mobile/features/social/domain/entites/friendship_status.dart';
import 'package:gymplanner_mobile/features/social/presentation/controller/public_profile_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../messaging/presentation/pages/chat_page.dart';

/// standardized_public_profile.html temel alınmıştır. NOT: Mockup'taki
/// workout/training-hour/friend-count/badge gibi istatistikler backend'de
/// karşılığı olmayan UYDURMA verilerdir VE başka bir kullanıcının özel
/// verilerini herkese açık göstermek gizlilik açısından tartışmalıdır.
/// Bu yüzden bilinçli olarak sadece kimlik + arkadaşlık durumu gösterilir.
class PublicProfilePage extends ConsumerWidget {
  final int userId;
  const PublicProfilePage({
    super.key,
    required this.userId,
  });

  Future<void> _handleMessage(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final conversationId = await ref
          .read(
            conversationsListControllerProvider
                .notifier,
          )
          .startConversationWith(userId);
      if (conversationId != null &&
          context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatPage(
              conversationId: conversationId,
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'PublicProfilePage - _handleMessage',
        error,
        stackTrace,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final asyncProfile = ref.watch(
      publicProfileControllerProvider(userId),
    );

    return Scaffold(
      appBar: AppBar(),
      body: asyncProfile.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(l10n.profileLoadError),
        ),
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor:
                      AppColors.primaryContainer,
                  child: Text(
                    profile
                            .user
                            .displayName
                            .isNotEmpty
                        ? profile
                              .user
                              .displayName[0]
                              .toUpperCase()
                        : '?',
                    style: AppTextStyles
                        .headlineLarge
                        .copyWith(
                          color: AppColors
                              .onPrimaryContainer,
                        ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Text(
                  profile.user.displayName,
                  style:
                      AppTextStyles.headlineLarge,
                ),
                Text(
                  '@${profile.user.username}',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                _ActionArea(
                  userId: userId,
                  profile: profile,
                  onMessage: () => _handleMessage(
                    context,
                    ref,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionArea extends ConsumerWidget {
  final int userId;
  final dynamic profile; // PublicProfileEntity
  final VoidCallback onMessage;

  const _ActionArea({
    required this.userId,
    required this.profile,
    required this.onMessage,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(
      publicProfileControllerProvider(
        userId,
      ).notifier,
    );

    switch (profile.friendshipStatus
        as FriendshipStatus) {
      case FriendshipStatus.self:
        return const SizedBox.shrink();

      case FriendshipStatus.none:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () =>
                controller.sendRequest(),
            icon: const Icon(
              Icons.person_add_outlined,
            ),
            label: Text(l10n.addFriendButton),
          ),
        );

      case FriendshipStatus.requestSent:
        return Chip(
          label: Text(
            l10n.friendshipRequestSentLabel,
          ),
        );

      case FriendshipStatus.requestReceived:
        return Column(
          children: [
            Text(
              l10n.friendshipRequestReceivedLabel,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => controller
                        .respondToRequest(
                          accept: false,
                        ),
                    child: Text(
                      l10n.declineButton,
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Expanded(
                  child: FilledButton(
                    onPressed: () => controller
                        .respondToRequest(
                          accept: true,
                        ),
                    child: Text(
                      l10n.acceptButton,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

      case FriendshipStatus.friends:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onMessage,
            icon: const Icon(
              Icons.chat_bubble_outline,
            ),
            label: Text(l10n.messageButtonLabel),
          ),
        );

      case FriendshipStatus.rejected:
        return Text(
          l10n.friendshipRejectedLabel,
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        );
    }
  }
}
