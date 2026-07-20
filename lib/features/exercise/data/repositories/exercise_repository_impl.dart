// repositories/exercise_repository_impl.dart

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/muscle_group_entity.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_datasource.dart';

class ExerciseRepositoryImpl
    implements ExerciseRepository {
  final ExerciseRemoteDataSource
  _remoteDataSource;
  const ExerciseRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<List<MuscleGroupEntity>>>
  getMuscleGroups() async {
    try {
      final dtos = await _remoteDataSource
          .getMuscleGroups();
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
              'ExerciseRepositoryImpl - getMuscleGroups',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<ExerciseEntity>>>
  getExercises({int? muscleGroupId}) async {
    try {
      final dtos = await _remoteDataSource
          .getExercises(
            muscleGroupId: muscleGroupId,
          );
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
              'ExerciseRepositoryImpl - getExercises',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<Set<int>>>
  getFavoriteExerciseIds() async {
    try {
      final ids = await _remoteDataSource
          .getFavoriteExerciseIds();
      return Success(ids);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'ExerciseRepositoryImpl - getFavoriteExerciseIds',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<bool>> toggleFavorite(
    int exerciseId,
  ) async {
    try {
      final isFavorite = await _remoteDataSource
          .toggleFavorite(exerciseId);
      return Success(isFavorite);
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'ExerciseRepositoryImpl - toggleFavorite',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
