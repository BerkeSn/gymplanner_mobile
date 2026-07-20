import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/exercise_library_controller.dart';

class ExerciseLibraryPage
    extends ConsumerStatefulWidget {
  const ExerciseLibraryPage({super.key});

  @override
  ConsumerState<ExerciseLibraryPage>
  createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState
    extends ConsumerState<ExerciseLibraryPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Egzersiz Kütüphanesi'),
      ),
      body: asyncState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => _ErrorView(
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
                      final isFavorite = state
                          .favoriteIds
                          .contains(exercise.id);
                      return _ExerciseListTile(
                        name: exercise.name,
                        muscleGroupName: exercise
                            .muscleGroupName,
                        equipmentName: exercise
                            .equipmentName,
                        difficulty:
                            exercise.difficulty,
                        imageUrl:
                            exercise.imageUrl,
                        isFavorite: isFavorite,
                        onFavoriteTap: () =>
                            controller
                                .toggleFavorite(
                                  exercise.id,
                                ),
                        onTap: () {
                          // TODO(faz3e): Egzersiz ilerleme detay sayfasına
                          // yönlendirilecek.
                        },
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
  final String name;
  final String muscleGroupName;
  final String equipmentName;
  final String difficulty;
  final String? imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const _ExerciseListTile({
    required this.name,
    required this.muscleGroupName,
    required this.equipmentName,
    required this.difficulty,
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteTap,
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
            _ExerciseThumbnail(
              imageUrl: imageUrl,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:
                        AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    '$muscleGroupName • $equipmentName • $difficulty',
                    style:
                        AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isFavorite
                    ? AppColors.error
                    : AppColors.outline,
              ),
              onPressed: onFavoriteTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// imageUrl null/boş olduğunda (backend seed'inde şu an TÜM egzersizlerin
/// imageUrl'i boş) kırık resim yerine sade bir ikon placeholder gösterir.
/// Medya altyapısı Faz 7'de bağlanınca gerçek görsel akacak, bu widget
/// hiç değişmeden çalışmaya devam edecek.
class _ExerciseThumbnail extends StatelessWidget {
  final String? imageUrl;
  const _ExerciseThumbnail({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          (imageUrl == null || imageUrl!.isEmpty)
          ? const Icon(
              Icons.fitness_center,
              color: AppColors.outline,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(
                12,
              ),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(
                      Icons.fitness_center,
                      color: AppColors.outline,
                    ),
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
            const Icon(
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
