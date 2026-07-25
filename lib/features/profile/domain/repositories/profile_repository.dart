import '../../../../core/error/result.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Result<UserEntity>> updateProfile({
    String? username,
    String? name,
    String? surname,
    String? phone,
    String? email,
    LocationPreference? locationPreference,
  });
}
