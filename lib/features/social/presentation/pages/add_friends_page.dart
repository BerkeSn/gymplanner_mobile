import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/social/domain/entites/friendship_request_entity.dart';
import 'package:gymplanner_mobile/features/social/domain/entites/user_summary_entity.dart';
import 'package:gymplanner_mobile/features/social/presentation/controller/pending_requests_controller.dart';
import 'package:gymplanner_mobile/features/social/presentation/controller/user_search_controller.dart';
import 'package:gymplanner_mobile/features/social/presentation/pages/public_profile_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class AddFriendsPage
    extends ConsumerStatefulWidget {
  const AddFriendsPage({super.key});

  @override
  ConsumerState<AddFriendsPage> createState() =>
      _AddFriendsPageState();
}

class _AddFriendsPageState
    extends ConsumerState<AddFriendsPage> {
  final _searchController =
      TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searchState = ref.watch(
      userSearchControllerProvider,
    );
    final searchController = ref.read(
      userSearchControllerProvider.notifier,
    );
    final pendingAsync = ref.watch(
      pendingRequestsControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addFriendsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          AppSpacing.containerMargin,
        ),
        children: [
          TextField(
            controller: _searchController,
            onChanged:
                searchController.updateQuery,
            decoration: InputDecoration(
              hintText: l10n.searchByNameHint,
              prefixIcon: const Icon(
                Icons.search,
              ),
              filled: true,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          if (searchState.query.trim().length < 2)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
              ),
              child: Text(
                l10n.searchMinCharsHint,
                style: AppTextStyles.bodyMedium,
              ),
            )
          else if (searchState.isSearching)
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
              ),
              child: Center(
                child:
                    CircularProgressIndicator(),
              ),
            )
          else if (searchState.results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
              ),
              child: Text(
                l10n.noSearchResults,
                style: AppTextStyles.bodyMedium,
              ),
            )
          else
            ...searchState.results.map(
              (user) => _SearchResultTile(
                user: user,
                isRequested: searchState
                    .requestedUserIds
                    .contains(user.id),
                onAdd: () => searchController
                    .sendRequest(user.id),
              ),
            ),

          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.pendingRequestsTitle,
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),

          pendingAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Text('$error'),
            data: (requests) {
              if (requests.isEmpty) {
                return Text(
                  l10n.noPendingRequests,
                  style: AppTextStyles.bodyMedium,
                );
              }
              return Column(
                children: requests
                    .map(
                      (
                        request,
                      ) => _PendingRequestTile(
                        request: request,
                        onAccept: () => ref
                            .read(
                              pendingRequestsControllerProvider
                                  .notifier,
                            )
                            .respond(
                              friendshipId: request
                                  .friendshipId,
                              accept: true,
                            ),
                        onDecline: () => ref
                            .read(
                              pendingRequestsControllerProvider
                                  .notifier,
                            )
                            .respond(
                              friendshipId: request
                                  .friendshipId,
                              accept: false,
                            ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final UserSummaryEntity user;
  final bool isRequested;
  final VoidCallback onAdd;

  const _SearchResultTile({
    required this.user,
    required this.isRequested,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      child: InkWell(
        // ⬅️ YENİ SARMALAYICI
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PublicProfilePage(
              userId: user.id,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  AppColors.primaryContainer,
              child: Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0]
                          .toUpperCase()
                    : '?',
                style: const TextStyle(
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
                    user.displayName,
                    style:
                        AppTextStyles.bodyLarge,
                  ),
                  Text(
                    '@${user.username}',
                    style:
                        AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            isRequested
                ? Chip(
                    label: Text(
                      l10n.requestSentLabel,
                    ),
                  )
                : FilledButton(
                    onPressed: onAdd,
                    child: Text(l10n.addButton),
                  ),
          ],
        ),
      ),
    );
  }
}

class _PendingRequestTile
    extends StatelessWidget {
  final FriendshipRequestEntity request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _PendingRequestTile({
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '@${request.requester.username}',
                style: AppTextStyles.bodyLarge,
              ),
            ),
            TextButton(
              onPressed: onDecline,
              child: Text(
                l10n.declineButton,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            FilledButton(
              onPressed: onAccept,
              child: Text(l10n.acceptButton),
            ),
          ],
        ),
      ),
    );
  }
}
