import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gymplanner_mobile/features/nutrition/presentation/controller/nutrition_controller.dart';
import 'package:gymplanner_mobile/features/nutrition/presentation/widgets/meal_tile.dart';
import 'package:gymplanner_mobile/features/walk_tracking/presentation/pages/active_walk_page.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/theme_selector_sheet.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../messaging/presentation/pages/messages_page.dart';
import '../../../nutrition/presentation/providers/meals_for_date_provider.dart';
import '../../../nutrition/presentation/widgets/log_meal_sheet.dart';
import '../../../workout_log/presentation/controllers/streak_analytics_controller.dart';
import '../../../workout_log/presentation/pages/workout_session_page.dart';
import '../../../workout_routine/domain/entities/week_day.dart';
import '../../../workout_routine/domain/entities/workout_routine_entity.dart';
import '../../../workout_routine/presentation/controllers/workout_programs_controller.dart';

class HomeDashboardPage
    extends ConsumerStatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  ConsumerState<HomeDashboardPage>
  createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState
    extends ConsumerState<HomeDashboardPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(
      now.year,
      now.month,
      now.day,
    ); // saat bileşenini at
  }

  WeekDay _weekDayFor(DateTime date) =>
      WeekDay.values[date.weekday - 1];

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;

  @override
  Widget build(BuildContext context) {
    try {
      final l10n = AppLocalizations.of(context);
      final authState = ref.watch(
        authControllerProvider,
      );
      final displayName =
          authState.valueOrNull?.name ?? 'Sporcu';
      final streakAsync = ref.watch(
        streakAnalyticsControllerProvider,
      );

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
            ),
            onPressed: () =>
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const MessagesPage(),
                  ),
                ),
          ),
          title: const Text('GymPlanner'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.dark_mode_outlined,
              ),
              onPressed: () =>
                  ThemeSelectorSheet.show(
                    context,
                  ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(
                999,
              ),
              onTap: () => context.go(
                AppRoutes.insights,
                extra: 1,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${streakAsync.valueOrNull?.currentStreak ?? '—'}',
                      style:
                          AppTextStyles.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _GreetingHeader(
                  displayName: displayName,
                  l10n: l10n,
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                _CalendarStrip(
                  selectedDate: _selectedDate,
                  onDateSelected: (date) =>
                      setState(
                        () =>
                            _selectedDate = date,
                      ),
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                _ActiveProgramSection(
                  selectedDate: _selectedDate,
                  weekDay: _weekDayFor(
                    _selectedDate,
                  ),
                  l10n: l10n,
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                _StartWalkBanner(),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                _CalorieSummaryCard(
                  selectedDate: _selectedDate,
                  l10n: l10n,
                ),
                const SizedBox(
                  height: AppSpacing.xl,
                ),
                _NutritionSection(
                  selectedDate: _selectedDate,
                  isToday: _isSameDate(
                    _selectedDate,
                    DateTime.now(),
                  ),
                  l10n: l10n,
                ),
              ],
            ),
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[HomeDashboardPage - build]: $error\n$stackTrace',
      );
      return const Scaffold(
        body: Center(
          child: Text('Bir şeyler ters gitti.'),
        ),
      );
    }
  }
}

class _GreetingHeader extends StatelessWidget {
  final String displayName;
  final AppLocalizations l10n;
  const _GreetingHeader({
    required this.displayName,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          l10n.welcomeGreetingLabel,
          style: AppTextStyles.labelSmall
              .copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          displayName,
          style: AppTextStyles.headlineLarge,
        ),
      ],
    );
  }
}

/// Bugünü merkez alan, gerçek tarihlere sahip 7 günlük şerit. Bir güne
/// dokununca Dashboard'un TÜM alt bölümleri (program/kalori/öğünler)
/// o güne göre yeniden hesaplanır.
class _CalendarStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarStrip({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final normalizedToday = DateTime(
      today.year,
      today.month,
      today.day,
    );
    final startDate = normalizedToday.subtract(
      const Duration(days: 3),
    );
    const weekdayLabels = [
      'Pzt',
      'Sal',
      'Çar',
      'Per',
      'Cum',
      'Cmt',
      'Paz',
    ];

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final date = startDate.add(
            Duration(days: index),
          );
          final isSelected =
              date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          return InkWell(
            borderRadius: BorderRadius.circular(
              12,
            ),
            onTap: () => onDateSelected(date),
            child: Container(
              width: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors
                          .surfaceContainerLow,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    weekdayLabels[date.weekday -
                        1],
                    style: AppTextStyles
                        .labelSmall
                        .copyWith(
                          color: isSelected
                              ? AppColors
                                    .onPrimary
                              : AppColors
                                    .onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    '${date.day}',
                    style: AppTextStyles
                        .headlineMedium
                        .copyWith(
                          color: isSelected
                              ? AppColors
                                    .onPrimary
                              : AppColors
                                    .onSurface,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Aktif programın SEÇİLİ GÜNE ait hareketlerini gösterir. Hareket varsa
/// tıklanınca doğrudan o günün antrenman oturumu başlar. Yoksa "Dinlenme
/// Günü" kartı gösterilir (tıklanamaz).
class _ActiveProgramSection
    extends ConsumerWidget {
  final DateTime selectedDate;
  final WeekDay weekDay;
  final AppLocalizations l10n;

  const _ActiveProgramSection({
    required this.selectedDate,
    required this.weekDay,
    required this.l10n,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final asyncRoutines = ref.watch(
      workoutProgramsControllerProvider,
    );

    return asyncRoutines.when(
      loading: () => const SizedBox(
        height: 96,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (routines) {
        final WorkoutRoutineEntity? active =
            routines
                .where((r) => r.isActive)
                .firstOrNull;

        if (active == null) {
          return _NoActiveProgramCard(l10n: l10n);
        }

        final dayExercises = active
            .routineExercises
            .where((e) => e.day == weekDay)
            .toList();

        if (dayExercises.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: AppColors
                  .surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.hotel,
                  color: AppColors.outline
                      .withValues(alpha: 0.5),
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Text(
                  l10n.restDayLabel,
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),
          );
        }

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WorkoutSessionPage(
                routineId: active.id,
                day: weekDay,
                exercises: dayExercises,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color:
                  AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        active.name,
                        style: AppTextStyles
                            .bodyLarge,
                      ),
                      const SizedBox(
                        height: AppSpacing.xs,
                      ),
                      Text(
                        '${dayExercises.length} ${l10n.exercisesCountSuffix}',
                        style: AppTextStyles
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.play_circle_outline,
                  color: AppColors.primary,
                  size: 32,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NoActiveProgramCard
    extends StatelessWidget {
  final AppLocalizations l10n;
  const _NoActiveProgramCard({
    required this.l10n,
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
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.noActiveProgramLabel,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          FilledButton(
            onPressed: () =>
                context.go(AppRoutes.fitness),
            child: Text(l10n.createProgramButton),
          ),
        ],
      ),
    );
  }
}

/// Haftalık Disiplin kartının yerini alan, sadece hedef/alınan kalori
/// gösteren sade özet — trend grafiği veya makrolar YOK (Beslenme
/// sekmesinde zaten mevcutlar, burada sadece hızlı bir bakış).
class _CalorieSummaryCard extends ConsumerWidget {
  final DateTime selectedDate;
  final AppLocalizations l10n;

  const _CalorieSummaryCard({
    required this.selectedDate,
    required this.l10n,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final nutritionState = ref.watch(
      nutritionControllerProvider,
    );
    final mealsAsync = ref.watch(
      mealsForDateProvider(selectedDate),
    );

    final targetCalories = nutritionState
        .valueOrNull
        ?.target
        ?.targetCalories;
    final consumedCalories =
        mealsAsync.valueOrNull?.totalCalories;

    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            l10n.calorieSummaryTitle,
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
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
                    targetCalories?.toString() ??
                        '—',
                    style: AppTextStyles
                        .headlineMedium,
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 32,
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
                    consumedCalories
                            ?.toString() ??
                        '0',
                    style: AppTextStyles
                        .headlineMedium,
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

/// Seçili günün TÜM öğünlerini listeler + tam genişlikte, aktif "Öğün Ekle"
/// butonu (o günün tarihiyle kaydeder).
class _NutritionSection extends ConsumerWidget {
  final DateTime selectedDate;
  final bool isToday;
  final AppLocalizations l10n;

  const _NutritionSection({
    required this.selectedDate,
    required this.isToday,
    required this.l10n,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final mealsAsync = ref.watch(
      mealsForDateProvider(selectedDate),
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mealsForSelectedDayTitle,
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        mealsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Text('$error'),
          data: (summary) {
            if (summary.meals.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                child: Text(
                  l10n.noMealsToday,
                  style: AppTextStyles.bodyMedium,
                ),
              );
            }
            return Column(
              children: summary.meals
                  .map(
                    (meal) => MealTile(
                      meal: meal,
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width:
              double.infinity, // ⬅️ tam genişlik
          child: FilledButton.icon(
            onPressed: () => LogMealSheet.show(
              context,
              date: selectedDate,
            ),
            icon: const Icon(Icons.add),
            label: Text(l10n.addMealButton),
          ),
        ),
      ],
    );
  }
}

class _StartWalkBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ActiveWalkPage(),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.directions_walk,
              color: AppColors.onPrimaryContainer,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                l10n.startWalkBanner,
                style: AppTextStyles.bodyLarge
                    .copyWith(
                      color: AppColors
                          .onPrimaryContainer,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
