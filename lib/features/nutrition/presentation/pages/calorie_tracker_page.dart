import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/features/nutrition/presentation/controller/nutrition_controller.dart';
import 'package:gymplanner_mobile/features/nutrition/presentation/widgets/log_meal_sheet.dart';
import 'package:gymplanner_mobile/features/nutrition/presentation/widgets/meal_tile.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/simple_line_chart.dart';
import '../../../../l10n/app_localizations.dart';

class CalorieTrackerPage extends ConsumerWidget {
  const CalorieTrackerPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(
      nutritionControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nutritionTitle),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
            onPressed: () =>
                LogMealSheet.show(context),
            icon: const Icon(Icons.add),
            label: Text(l10n.addMealButton),
          ),
      body: asyncState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) =>
            Center(child: Text('$error')),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref
              .read(
                nutritionControllerProvider
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
              _CalorieProgressCard(
                targetCalories:
                    state.target?.targetCalories,
                consumedCalories:
                    state.summary.totalCalories,
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              Text(
                'Besin Değeri',
                style:
                    AppTextStyles.headlineMedium,
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              _MacroCell(
                label: l10n.proteinLabel,
                value: state.summary.totalProtein,
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              _MacroCell(
                label: l10n.carbsLabel,
                value: state.summary.totalCarbs,
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              _MacroCell(
                label: l10n.fatsLabel,
                value: state.summary.totalFats,
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              Text(
                l10n.thirtyDayTrendTitle,
                style:
                    AppTextStyles.headlineMedium,
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              Container(
                padding: const EdgeInsets.all(
                  AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  color: AppColors
                      .surfaceContainerLowest,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors
                        .outlineVariant
                        .withValues(alpha: 0.15),
                  ),
                ),
                child: SimpleLineChart(
                  values: state.trend
                      .map(
                        (p) => p.totalCalories
                            .toDouble(),
                      )
                      .toList(),
                  height: 140,
                ),
              ),
              const SizedBox(
                height: AppSpacing.xl,
              ),
              Text(
                l10n.recentMealsTitle,
                style:
                    AppTextStyles.headlineMedium,
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              if (state.summary.meals.isEmpty)
                Text(
                  l10n.noMealsToday,
                  style: AppTextStyles.bodyMedium,
                )
              else
                ...state.summary.meals.reversed.map(
                  (meal) => MealTile(
                    meal: meal,
                    onDelete: () => ref
                        .read(
                          nutritionControllerProvider
                              .notifier,
                        )
                        .deleteMeal(meal.id),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalorieProgressCard
    extends StatelessWidget {
  final int? targetCalories;
  final int consumedCalories;

  const _CalorieProgressCard({
    required this.targetCalories,
    required this.consumedCalories,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final target = targetCalories ?? 0;
    final remaining = target - consumedCalories;
    final progress = target > 0
        ? (consumedCalories / target).clamp(
            0.0,
            1.0,
          )
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: AppColors
                        .surfaceContainerHigh,
                    valueColor:
                        AlwaysStoppedAnimation(
                          AppColors
                              .primaryContainer,
                        ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      targetCalories == null
                          ? '—'
                          : '$remaining',
                      style: AppTextStyles
                          .headlineLarge,
                    ),
                    Text(
                      l10n.kcalLeftLabel,
                      style: AppTextStyles
                          .labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    l10n.targetLabel,
                    style:
                        AppTextStyles.bodyMedium,
                  ),
                  Text(
                    targetCalories == null
                        ? '—'
                        : '$targetCalories',
                    style:
                        AppTextStyles.bodyLarge,
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 24,
                color: AppColors.outlineVariant,
              ),
              Column(
                children: [
                  Text(
                    l10n.foodLabel,
                    style:
                        AppTextStyles.bodyMedium,
                  ),
                  Text(
                    '$consumedCalories',
                    style:
                        AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroCell extends StatelessWidget {
  final String label;
  final double value;
  const _MacroCell({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelSmall,
          ),
          Text(
            '${value.toStringAsFixed(0)} g',
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}
