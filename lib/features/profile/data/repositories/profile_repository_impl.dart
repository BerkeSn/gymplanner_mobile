// repositories/profile_repository_impl.dart

import 'package:gymplanner_mobile/features/profile/data/datasource/profile_remote_datasource.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/error/result.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl
    implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  const ProfileRepositoryImpl(
    this._remoteDataSource,
  );

  @override
  Future<Result<UserEntity>> updateProfile({
    String? username,
    String? name,
    String? surname,
    String? phone,
    String? email,
    LocationPreference? locationPreference,
    UserGoal? goal,
    ActivityLevel? activityLevel,
  }) async {
    try {
      final dto = await _remoteDataSource
          .updateProfile(
            username: username,
            name: name,
            surname: surname,
            phone: phone,
            email: email,
            locationPreference:
                locationPreference?.apiValue,
            goal: goal?.apiValue,
            activityLevel:
                activityLevel?.apiValue,
          );
      return Success(dto.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error, stackTrace) {
      return Failure(
        AppExceptionFactory.unexpected(
          source:
              'ProfileRepositoryImpl - updateProfile',
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
