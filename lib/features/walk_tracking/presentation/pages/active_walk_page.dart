import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/walk_tracking/presentation/controller/live_walk_controller.dart';
import 'package:gymplanner_mobile/features/walk_tracking/presentation/pages/walk_summary_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class ActiveWalkPage
    extends ConsumerStatefulWidget {
  const ActiveWalkPage({super.key});

  @override
  ConsumerState<ActiveWalkPage> createState() =>
      _ActiveWalkPageState();
}

class _ActiveWalkPageState
    extends ConsumerState<ActiveWalkPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _startTracking(),
    );
  }

  Future<void> _startTracking() async {
    final l10n = AppLocalizations.of(context);
    final started = await ref
        .read(liveWalkControllerProvider.notifier)
        .start();
    if (!started && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.locationPermissionDenied,
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleFinish() async {
    final walk = await ref
        .read(liveWalkControllerProvider.notifier)
        .finish();
    if (!mounted) return;

    if (walk != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              WalkSummaryPage(walk: walk),
        ),
      );
    } else {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.walkSaveError),
        ),
      );
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60)
        .toString()
        .padLeft(2, '0');
    final secs = (seconds % 60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(
      liveWalkControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activeWalkTitle),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 260,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 260,
                      height: 260,
                      child: CircularProgressIndicator(
                        value:
                            null, // Belirsiz süreç göstergesi — sabit bir hedef yok.
                        strokeWidth: 6,
                        backgroundColor: AppColors
                            .surfaceContainerHigh,
                        valueColor:
                            const AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                      ),
                    ),
                    Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Text(
                          '${state.steps}',
                          style: AppTextStyles
                              .headlineLarge,
                        ),
                        Text(
                          l10n.stepsLabel,
                          style: AppTextStyles
                              .labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                _MetricColumn(
                  label: l10n.distanceLabel,
                  value:
                      '${(state.distanceMeters / 1000).toStringAsFixed(2)} km',
                ),
                _MetricColumn(
                  label: l10n.durationLabel,
                  value: _formatDuration(
                    state.elapsedSeconds,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ref
                        .read(
                          liveWalkControllerProvider
                              .notifier,
                        )
                        .togglePause(),
                    icon: Icon(
                      state.isPaused
                          ? Icons.play_arrow
                          : Icons.pause,
                    ),
                    label: Text(
                      state.isPaused
                          ? l10n.resumeButton
                          : l10n.pauseButton,
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSpacing.md,
                ),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _handleFinish,
                    icon: const Icon(Icons.check),
                    label: Text(
                      l10n.finishButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  const _MetricColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelSmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.headlineMedium,
        ),
      ],
    );
  }
}
