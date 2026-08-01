import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/workout_log/domain/entites/streak_analytics_entity.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/streak_analytics_controller.dart';

class StreakAnalyticsView extends ConsumerWidget {
  const StreakAnalyticsView({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final asyncState = ref.watch(
      streakAnalyticsControllerProvider,
    );

    return asyncState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) =>
          Center(child: Text('$error')),
      data: (analytics) => RefreshIndicator(
        onRefresh: () => ref
            .read(
              streakAnalyticsControllerProvider
                  .notifier,
            )
            .refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.containerMargin,
            AppSpacing.containerMargin,
            AppSpacing.containerMargin,
            96,
          ),
          children: [
            _ConsistencyRing(
              analytics: analytics,
            ),
            const SizedBox(height: AppSpacing.xl),
            _MonthCalendar(analytics: analytics),
            const SizedBox(height: AppSpacing.xl),
            _AttendanceSummaryGrid(
              analytics: analytics,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsistencyRing extends StatelessWidget {
  final StreakAnalyticsEntity analytics;
  const _ConsistencyRing({
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final activeDaysThisMonth = analytics
        .activeDates
        .where(
          (d) =>
              d.year == now.year &&
              d.month == now.month,
        )
        .length;
    final progress = now.day > 0
        ? (activeDaysThisMonth / now.day).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: AppColors
                        .surfaceContainerHigh,
                    valueColor:
                        const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: AppTextStyles
                          .headlineLarge,
                    ),
                    Text(
                      l10n.consistencyLabel,
                      style: AppTextStyles
                          .labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  final StreakAnalyticsEntity analytics;
  const _MonthCalendar({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(
      now.year,
      now.month,
      1,
    );
    final daysInMonth = DateTime(
      now.year,
      now.month + 1,
      0,
    ).day;
    // Pazartesi = 0 olacak şekilde offset (WeekDay kullanımımızla tutarlı).
    final leadingEmptyCells =
        firstDayOfMonth.weekday - 1;

    final weekdayLabels = [
      'P',
      'S',
      'Ç',
      'P',
      'C',
      'C',
      'P',
    ];

    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _monthLabel(now.month),
                style:
                    AppTextStyles.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: [
              ...weekdayLabels.map(
                (label) => Center(
                  child: Text(
                    label,
                    style: AppTextStyles
                        .labelSmall
                        .copyWith(
                          color:
                              AppColors.outline,
                        ),
                  ),
                ),
              ),
              ...List.generate(
                leadingEmptyCells,
                (_) => const SizedBox.shrink(),
              ),
              ...List.generate(daysInMonth, (
                index,
              ) {
                final day = index + 1;
                final date = DateTime(
                  now.year,
                  now.month,
                  day,
                );
                final isActive = analytics
                    .isActiveOn(date);
                final isFuture = date.isAfter(
                  now,
                );
                return Container(
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : isFuture
                        ? Colors.transparent
                        : AppColors
                              .surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: AppTextStyles
                          .labelSmall
                          .copyWith(
                            color: isActive
                                ? AppColors
                                      .onPrimary
                                : AppColors
                                      .onSurfaceVariant,
                          ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              _LegendDot(
                color: AppColors.primary,
                label: AppLocalizations.of(
                  context,
                ).activeDayLegend,
              ),
              const SizedBox(
                width: AppSpacing.lg,
              ),
              _LegendDot(
                color: AppColors
                    .surfaceContainerHigh,
                label: AppLocalizations.of(
                  context,
                ).missedDayLegend,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _monthLabel(int month) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return months[month - 1];
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.labelSmall,
        ),
      ],
    );
  }
}

class _AttendanceSummaryGrid
    extends StatelessWidget {
  final StreakAnalyticsEntity analytics;
  const _AttendanceSummaryGrid({
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final activeDaysThisMonth = analytics
        .activeDates
        .where(
          (d) =>
              d.year == now.year &&
              d.month == now.month,
        )
        .length;
    final missedDaysThisMonth =
        now.day - activeDaysThisMonth;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCell(
                label: l10n.currentStreakLabel,
                value:
                    '${analytics.currentStreak}',
                sublabel:
                    l10n.consecutiveDaysLabel,
                icon: Icons.local_fire_department,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SummaryCell(
                label: l10n.longestStreakLabel,
                value:
                    '${analytics.longestStreak}',
                sublabel: l10n.allTimeRecordLabel,
                icon: Icons.military_tech,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _SummaryCell(
                label: l10n.totalActiveLabel,
                value:
                    '${analytics.totalActiveDays}',
                icon: Icons.done_all,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _SummaryCell(
                label: l10n.totalMissedLabel,
                value:
                    '${missedDaysThisMonth < 0 ? 0 : missedDaysThisMonth}',
                icon: Icons.close,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;
  final String? sublabel;
  final IconData icon;

  const _SummaryCell({
    required this.label,
    required this.value,
    this.sublabel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.labelSmall,
              ),
              Icon(
                icon,
                size: 16,
                color: AppColors.primary
                    .withValues(alpha: 0.4),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.headlineLarge,
          ),
          if (sublabel != null)
            Text(
              sublabel!,
              style: AppTextStyles.bodyMedium,
            ),
        ],
      ),
    );
  }
}
