// repositories/exercise_progress_repository.dart

import '../../../../core/error/result.dart';
import '../entities/exercise_progress_entry.dart';

abstract class ExerciseProgressRepository {
  /// Backend zaten tarihe göre ARTAN sırayla döndürüyor (bkz.
  /// workoutLogsController.js - getExerciseProgress), tekrar sıralamaya
  /// gerek yok.
  Future<Result<List<ExerciseProgressEntry>>>
  getProgress(int exerciseId);
}
