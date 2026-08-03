// features/profile/domain/repositories/profile_repository.dart

import 'package:gymplanner_mobile/core/error/result.dart';
import 'package:gymplanner_mobile/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Result<UserEntity>> updateProfile({
    String? username,
    String? name,
    String? surname,
    String? phone,
    String? email,
    LocationPreference? locationPreference,
    UserGoal? goal, // ⬅️ YENİ
    ActivityLevel? activityLevel, // ⬅️ YENİ
  });
}
