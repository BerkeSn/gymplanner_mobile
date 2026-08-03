// lib/features/exercise/presentation/widgets/exercise_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/exercise_placeholder_thumbnail.dart';
import '../../domain/entities/exercise_entity.dart';
import '../controllers/exercise_library_controller.dart';

typedef ExerciseTapCallback =
    void Function(ExerciseEntity exercise);
typedef ExerciseTrailingBuilder =
    Widget Function(
      BuildContext context,
      ExerciseEntity exercise,
    );

/// Egzersiz Kütüphanesi (gözat/favorile) ve Egzersiz Seçim (programa ekle)
/// ekranları arasında paylaşılan arama + kas grubu filtresi + liste UI'ı.
/// Aynı görsel dili iki farklı AMAÇ için tekrar kullanır — kopya kod yerine
/// tek kaynaktan yönetilir, biri güncellenince ikisi de senkron kalır.
class ExerciseListView
    extends ConsumerStatefulWidget {
  final ExerciseTapCallback onExerciseTap;
  final ExerciseTrailingBuilder? trailingBuilder;

  const ExerciseListView({
    super.key,
    required this.onExerciseTap,
    this.trailingBuilder,
  });

  @override
  ConsumerState<ExerciseListView> createState() =>
      _ExerciseListViewState();
}

class _ExerciseListViewState
    extends ConsumerState<ExerciseListView> {
  final _searchController =
      TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(
      exerciseLibraryControllerProvider,
    );
    final controller = ref.read(
      exerciseLibraryControllerProvider.notifier,
    );

    return asyncState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => _ErrorView(
        message: error.toString(),
        onRetry: () =>
            controller.selectMuscleGroup(null),
      ),
      data: (state) => RefreshIndicator(
        onRefresh: () =>
            controller.selectMuscleGroup(
              state.selectedMuscleGroupId,
            ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppSpacing.containerMargin,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller:
                          _searchController,
                      onChanged: controller
                          .updateSearchQuery,
                      decoration:
                          const InputDecoration(
                            hintText:
                                'Hareket ara...',
                            prefixIcon: Icon(
                              Icons.search,
                            ),
                            filled: true,
                          ),
                    ),
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                    Text(
                      'Bölge',
                      style: AppTextStyles
                          .labelSmall,
                    ),
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    _MuscleGroupChips(
                      state: state,
                      onSelected: controller
                          .selectMuscleGroup,
                    ),
                  ],
                ),
              ),
            ),
            if (state.filteredExercises.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Sonuç bulunamadı.',
                  ),
                ),
              )
            else
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(
                      horizontal: AppSpacing
                          .containerMargin,
                    ),
                sliver: SliverList.separated(
                  itemCount: state
                      .filteredExercises
                      .length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(
                        height: AppSpacing.sm,
                      ),
                  itemBuilder: (context, index) {
                    final exercise = state
                        .filteredExercises[index];
                    return _ExerciseListTile(
                      exercise: exercise,
                      trailing: widget
                          .trailingBuilder
                          ?.call(
                            context,
                            exercise,
                          ),
                      onTap: () =>
                          widget.onExerciseTap(
                            exercise,
                          ),
                    );
                  },
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: AppSpacing.xl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MuscleGroupChips extends StatelessWidget {
  final ExerciseLibraryState state;
  final ValueChanged<int?> onSelected;

  const _MuscleGroupChips({
    required this.state,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: AppSpacing.sm,
            ),
            child: ChoiceChip(
              label: const Text('Tümü'),
              selected:
                  state.selectedMuscleGroupId ==
                  null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          ...state.muscleGroups.map((group) {
            return Padding(
              padding: const EdgeInsets.only(
                right: AppSpacing.sm,
              ),
              child: ChoiceChip(
                label: Text(group.name),
                selected:
                    state.selectedMuscleGroupId ==
                    group.id,
                onSelected: (_) =>
                    onSelected(group.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ExerciseListTile extends StatelessWidget {
  final ExerciseEntity exercise;
  final Widget? trailing;
  final VoidCallback onTap;

  const _ExerciseListTile({
    required this.exercise,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            ExercisePlaceholderThumbnail(
              imageUrl: exercise.imageUrl,
              muscleGroupName:
                  exercise.muscleGroupName,
              size: 64,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style:
                        AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Row(
                    children: [
                      _DifficultyBadge(
                        difficulty:
                            exercise.difficulty,
                      ),
                      const SizedBox(
                        width: AppSpacing.xs,
                      ),
                      Expanded(
                        child: Text(
                          '${exercise.muscleGroupName} • ${exercise.equipmentName}',
                          style: AppTextStyles
                              .bodyMedium,
                          overflow: TextOverflow
                              .ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer
            .withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        difficulty,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 9,
          color: AppColors.tertiary,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
