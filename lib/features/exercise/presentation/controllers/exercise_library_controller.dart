// presentation/controllers/exercise_library_controller.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/muscle_group_entity.dart';
import '../providers/exercise_providers.dart';

part 'exercise_library_controller.g.dart';

class ExerciseLibraryState {
  final List<MuscleGroupEntity> muscleGroups;
  final List<ExerciseEntity> exercises;
  final Set<int> favoriteIds;
  final int? selectedMuscleGroupId;
  final String searchQuery;
  final ExerciseLocation?
  locationFilter;
  final bool favoritesOnly;

  const ExerciseLibraryState({
    this.muscleGroups = const [],
    this.exercises = const [],
    this.favoriteIds = const {},
    this.selectedMuscleGroupId,
    this.searchQuery = '',
    this.locationFilter,
    this.favoritesOnly = false,
  });

  List<ExerciseEntity> get filteredExercises {
    var result = exercises;

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery
          .trim()
          .toLowerCase();
      result = result
          .where(
            (e) => e.name.toLowerCase().contains(
              query,
            ),
          )
          .toList();
    }

    if (locationFilter != null) {
      result = result
          .where(
            (e) => e.availableAt.matchesFilter(
              locationFilter,
            ),
          )
          .toList();
    }

    if (favoritesOnly) {
      result = result
          .where(
            (e) => favoriteIds.contains(e.id),
          )
          .toList();
    }

    return result;
  }

  

  ExerciseLibraryState copyWith({
    List<MuscleGroupEntity>? muscleGroups,
    List<ExerciseEntity>? exercises,
    Set<int>? favoriteIds,
    int? Function()? selectedMuscleGroupId,
    String? searchQuery,
    ExerciseLocation? Function()?
    locationFilter,
    bool? favoritesOnly,
  }) {
return ExerciseLibraryState(
      muscleGroups:
          muscleGroups ?? this.muscleGroups,
      exercises: exercises ?? this.exercises,
      favoriteIds:
          favoriteIds ?? this.favoriteIds,
      selectedMuscleGroupId:
          selectedMuscleGroupId != null
          ? selectedMuscleGroupId()
          : this.selectedMuscleGroupId,
      searchQuery:
          searchQuery ?? this.searchQuery,
      locationFilter: locationFilter != null
          ? locationFilter()
          : this.locationFilter,
      favoritesOnly:
          favoritesOnly ?? this.favoritesOnly,
    );
  }
}

@Riverpod(keepAlive: true)
class ExerciseLibraryController
    extends _$ExerciseLibraryController {
  @override
  FutureOr<ExerciseLibraryState> build() async {
    return _loadAll(null);
  }

  Future<ExerciseLibraryState> _loadAll(
    int? muscleGroupId,
  ) async {
    try {
      final repository = ref.read(
        exerciseRepositoryProvider,
      );

      final muscleGroupsResult = await repository
          .getMuscleGroups();
      final exercisesResult = await repository
          .getExercises(
            muscleGroupId: muscleGroupId,
          );
      final favoritesResult = await repository
          .getFavoriteExerciseIds();

      // Üç çağrıdan biri bile başarısızsa kullanıcıya net hata dönelim.
      if (muscleGroupsResult
          is Failure<List<MuscleGroupEntity>>) {
        throw muscleGroupsResult.exception;
      }
      if (exercisesResult
          is Failure<List<ExerciseEntity>>) {
        throw exercisesResult.exception;
      }

      final muscleGroups =
          (muscleGroupsResult
                  as Success<
                    List<MuscleGroupEntity>
                  >)
              .data;
      final exercises =
          (exercisesResult
                  as Success<
                    List<ExerciseEntity>
                  >)
              .data;
      final favoriteIds =
          favoritesResult is Success<Set<int>>
          ? favoritesResult.data
          : <
              int
            >{}; // Favoriler alınamazsa sessizce boş küme — kritik değil.

      return ExerciseLibraryState(
        muscleGroups: muscleGroups,
        exercises: exercises,
        favoriteIds: favoriteIds,
        selectedMuscleGroupId: muscleGroupId,
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'ExerciseLibraryController - _loadAll',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> selectMuscleGroup(
    int? muscleGroupId,
  ) async {
    try {
      state =
          const AsyncLoading<
                ExerciseLibraryState
              >()
              .copyWithPrevious(state);
      final newState = await _loadAll(
        muscleGroupId,
      );
      state = AsyncData(newState);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  void updateSearchQuery(String query) {
    try {
      final current = state.valueOrNull;
      if (current == null) return;
      state = AsyncData(
        current.copyWith(searchQuery: query),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'ExerciseLibraryController - updateSearchQuery',
        error,
        stackTrace,
      );
    }
  }

  void updateLocationFilter(
    ExerciseLocation? location,
  ) {
    try {
      final current = state.valueOrNull;
      if (current == null) return;
      state = AsyncData(
        current.copyWith(
          locationFilter: () => location,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'ExerciseLibraryController - updateLocationFilter',
        error,
        stackTrace,
      );
    }
  }

  void toggleFavoritesOnly() {
    try {
      final current = state.valueOrNull;
      if (current == null) return;
      state = AsyncData(
        current.copyWith(
          favoritesOnly: !current.favoritesOnly,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'ExerciseLibraryController - toggleFavoritesOnly',
        error,
        stackTrace,
      );
    }
  }

  Future<void> toggleFavorite(
    int exerciseId,
  ) async {
    final current = state.valueOrNull;
    if (current == null) return;

    // Optimistic update: backend cevabını beklemeden UI'ı anında güncelle,
    // başarısız olursa geri al. Favori butonuna basınca gecikme hissedilmesin.
    final wasAlreadyFavorite = current.favoriteIds
        .contains(exerciseId);
    final optimisticIds = Set<int>.from(
      current.favoriteIds,
    );
    wasAlreadyFavorite
        ? optimisticIds.remove(exerciseId)
        : optimisticIds.add(exerciseId);
    state = AsyncData(
      current.copyWith(
        favoriteIds: optimisticIds,
      ),
    );

    try {
      final repository = ref.read(
        exerciseRepositoryProvider,
      );
      final result = await repository
          .toggleFavorite(exerciseId);

      if (result is Failure<bool>) {
        throw result.exception;
      }
    } catch (error, stackTrace) {
      AppLogger.error(
        'ExerciseLibraryController - toggleFavorite',
        error,
        stackTrace,
      );
      // Geri al: optimistic update'i eski haline döndür.
      state = AsyncData(current);
    }
  }
}
