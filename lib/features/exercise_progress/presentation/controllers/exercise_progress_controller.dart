// presentation/controllers/exercise_progress_controller.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/exercise_progress_entry.dart';
import '../providers/exercise_progress_providers.dart';

part 'exercise_progress_controller.g.dart';

/// family: her exerciseId için bağımsız state. Kasıtlı olarak autoDispose
/// (varsayılan @riverpod) — bu bir detay ekranı, ekrandan çıkınca veri
/// belleğinden silinmeli, geri dönüldüğünde taze veri çekilmeli.
@riverpod
Future<List<ExerciseProgressEntry>>
exerciseProgress(
  ExerciseProgressRef ref,
  int exerciseId,
) async {
  try {
    final repository = ref.read(
      exerciseProgressRepositoryProvider,
    );
    final result = await repository.getProgress(
      exerciseId,
    );
    if (result
        is Failure<List<ExerciseProgressEntry>>) {
      throw result.exception;
    }
    return (result
            as Success<
              List<ExerciseProgressEntry>
            >)
        .data;
  } catch (error, stackTrace) {
    AppLogger.error(
      'exerciseProgress - provider',
      error,
      stackTrace,
    );
    rethrow;
  }
}
