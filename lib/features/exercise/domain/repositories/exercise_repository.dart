// repositories/exercise_repository.dart

import 'package:gymplanner_mobile/features/exercise/domain/entities/exercise_entity.dart';
import 'package:gymplanner_mobile/features/exercise/domain/entities/muscle_group_entity.dart';

import '../../../../../core/error/result.dart';

abstract class ExerciseRepository {
  Future<Result<List<MuscleGroupEntity>>>
  getMuscleGroups();

  /// muscleGroupId null ise tüm egzersizler döner.
  Future<Result<List<ExerciseEntity>>>
  getExercises({int? muscleGroupId});

  /// Kullanıcının favori işaretlediği egzersiz ID'lerinin kümesi.
  /// Set kullanıyoruz çünkü UI'da "bu egzersiz favori mi?" kontrolü O(1) olmalı.
  Future<Result<Set<int>>>
  getFavoriteExerciseIds();

  /// Favori durumunu değiştirir, backend'in döndürdüğü YENİ durumu verir.
  Future<Result<bool>> toggleFavorite(
    int exerciseId,
  );
}
