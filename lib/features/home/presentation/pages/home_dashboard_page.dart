import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/core/widgets/language_toggle_button.dart';
import 'package:gymplanner_mobile/core/widgets/theme_selector_sheet.dart';
import 'package:gymplanner_mobile/features/walk_tracking/presentation/pages/active_walk_page.dart';
import 'package:gymplanner_mobile/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    try {
      final authState = ref.watch(
        authControllerProvider,
      );
      final displayName =
          authState.valueOrNull?.name ?? 'Sporcu';

      return Scaffold(
        appBar: AppBar(
          title: const Text('GymPlanner'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.palette_outlined,
              ),
              onPressed: () =>
                  ThemeSelectorSheet.show(
                    context,
                  )
            ),
            const LanguageToggleButton(),
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
              ),
              onPressed: () {
                // TODO(faz7): Ayarlar sayfası bağlanacak — dil toggle'ı da
                // gerçek Ayarlar sayfasına taşınacak, şimdilik burada test amaçlı.
              },
            ),

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
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                const _CalendarStrip(),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                const _ActiveRoutineCard(),

                const SizedBox(
                  height: AppSpacing.lg,
                ),
                _StartWalkBanner(),

                const SizedBox(
                  height: AppSpacing.lg,
                ),
                const _WeeklyDisciplineCard(),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                const _NutritionSummarySection(),
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
  const _GreetingHeader({
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'HOŞ GELDİN',
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

/// TODO(faz3): Günler gerçek WorkoutLog tarihleriyle işaretlenecek
/// (hangi günde antrenman yapılmış gösterilecek).
class _CalendarStrip extends StatelessWidget {
  const _CalendarStrip();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdayLabels = [
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
          final isToday =
              index == (now.weekday - 1);
          return Container(
            width: 52,
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primary
                  : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  weekdayLabels[index],
                  style: AppTextStyles.labelSmall
                      .copyWith(
                        color: isToday
                            ? AppColors.onPrimary
                            : AppColors
                                  .onSurfaceVariant,
                      ),
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Text(
                  '${index + 1}',
                  style: AppTextStyles
                      .headlineMedium
                      .copyWith(
                        color: isToday
                            ? AppColors.onPrimary
                            : AppColors.onSurface,
                        fontSize: 18,
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

/// TODO(faz3): "Aktif Protokol" WorkoutRoutine.isActive=true olan kayıttan
/// gelecek. Şu an statik placeholder.
class _ActiveRoutineCard extends StatelessWidget {
  const _ActiveRoutineCard();

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
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'AKTİF PROGRAM',
                  style: AppTextStyles.labelSmall
                      .copyWith(
                        color:
                            AppColors.secondary,
                      ),
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Text(
                  'Henüz bir program seçilmedi',
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {
              // TODO(faz3): Program oluşturma/seçme akışına yönlendirilecek.
            },
            child: const Text('Başla'),
          ),
        ],
      ),
    );
  }
}

/// TODO(faz6): Gerçek streak/haftalık hacim verisi backend'deki
/// yeni analytics endpoint'inden gelecek (bkz. Faz 6 - Streak Analytics).
class _WeeklyDisciplineCard
    extends StatelessWidget {
  const _WeeklyDisciplineCard();

  @override
  Widget build(BuildContext context) {
    final dayLabels = [
      'P',
      'S',
      'Ç',
      'P',
      'C',
      'C',
      'P',
    ];
    final barHeights = [
      0.4,
      0.6,
      0.35,
      0.75,
      0.9,
      0.1,
      0.1,
    ];

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
            'Haftalık Disiplin',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                    child: FractionallySizedBox(
                      heightFactor: barHeights[i],
                      alignment:
                          Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary
                              .withValues(
                                alpha: 0.7,
                              ),
                          borderRadius:
                              const BorderRadius.vertical(
                                top:
                                    Radius.circular(
                                      4,
                                    ),
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: dayLabels
                .map(
                  (d) => Text(
                    d,
                    style:
                        AppTextStyles.labelSmall,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// TODO(faz4): CalorieEntry / yeni MealEntry backend endpoint'ine bağlanacak.
class _NutritionSummarySection
    extends StatelessWidget {
  const _NutritionSummarySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Beslenme Günlüğü',
          style: AppTextStyles.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color:
                AppColors.surfaceContainerLowest,
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.3),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Henüz öğün eklenmedi.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              OutlinedButton(
                onPressed: () {
                  // TODO(faz4): Öğün ekleme modalına yönlendirilecek.
                },
                child: const Text('Öğün Ekle'),
              ),
            ],
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
