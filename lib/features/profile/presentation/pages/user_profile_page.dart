import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymplanner_mobile/features/body_measurement/presentation/controller/body_measurement_controller.dart';
import 'package:gymplanner_mobile/features/messaging/presentation/pages/messages_page.dart';
import 'package:gymplanner_mobile/features/social/presentation/pages/add_friends_page.dart';
import 'package:gymplanner_mobile/features/walk_tracking/presentation/pages/walk_history_page.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../workout_log/presentation/providers/workout_log_providers.dart';
import 'edit_profile_page.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  Future<void> _handleLogout(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(true),
            child: Text(
              l10n.logoutButton,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref
          .read(authControllerProvider.notifier)
          .logout();
      if (context.mounted)
        context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final user = ref
        .watch(authControllerProvider)
        .valueOrNull;
    final measurementCount =
        ref
            .watch(
              bodyMeasurementControllerProvider,
            )
            .valueOrNull
            ?.length ??
        0;
    final workoutCountAsync = ref.watch(
      completedWorkoutCountProvider,
    );

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const EditProfilePage(),
                  ),
                ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          AppSpacing.containerMargin,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor:
                  AppColors.primaryContainer,
              child: Text(
                user.name.isNotEmpty
                    ? user.name[0].toUpperCase()
                    : '?',
                style: AppTextStyles.headlineLarge
                    .copyWith(
                      color: AppColors
                          .onPrimaryContainer,
                    ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${user.name} ${user.surname}',
              style: AppTextStyles.headlineMedium,
            ),
            Text(
              '@${user.username}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: _StatCell(
                    label:
                        l10n.totalWorkoutsLabel,
                    value:
                        workoutCountAsync
                            .valueOrNull
                            ?.toString() ??
                        '—',
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: _StatCell(
                    label: l10n
                        .totalMeasurementsLabel,
                    value: '$measurementCount',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.quickActionsTitle,
                style:
                    AppTextStyles.headlineMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _MenuRow(
              icon: Icons.straighten,
              label:
                  l10n.bodyMeasurementsMenuItem,
              onTap: () =>
                  context.go(AppRoutes.insights),
            ),
            const SizedBox(height: AppSpacing.sm),
            _MenuRow(
              icon: Icons.fitness_center,
              label: l10n.activeProgramMenuItem,
              onTap: () =>
                  context.go(AppRoutes.fitness),
            ),
            const SizedBox(height: AppSpacing.sm),
            _MenuRow(
              icon: Icons.person_add_outlined,
              label: l10n.addFriendsTitle,
              onTap: () =>
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const AddFriendsPage(),
                    ),
                  ),
            ),

            const SizedBox(height: AppSpacing.sm),
            _MenuRow(
              icon: Icons.chat_bubble_outline,
              label: l10n.messagesTitle,
              onTap: () =>
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const MessagesPage(),
                    ),
                  ),
            ),

            const SizedBox(height: AppSpacing.sm),
            _MenuRow(
              icon: Icons.directions_walk,
              label: l10n.walkHistoryTitle,
              onTap: () =>
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const WalkHistoryPage(),
                    ),
                  ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    _handleLogout(context, ref),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                label: Text(
                  l10n.logoutButton,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  const _StatCell({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}
