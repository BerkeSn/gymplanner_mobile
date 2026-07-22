// repositories/exercise_progress_repository_impl.dart

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/exercise_progress_entry.dart';
import '../../domain/repositories/exercise_progress_repository.dart';
import '../datasources/exercise_progress_remote_datasource.dart';

class ExerciseProgressRepositoryImpl
    implements ExerciseProgressRepository {
  final ExerciseProgressRemoteDataSource
  _remoteDataSource;
  const ExerciseProgressRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<List<ExerciseProgressEntry>>>
  getProgress(int exerciseId) async {
    try {
      final dtos = await _remoteDataSource
          .getProgress(exerciseId);
      return Success(
        dtos
            .map((dto) => dto.toEntity())
            .toList(),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'ExerciseProgressRepositoryImpl - getProgress',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
