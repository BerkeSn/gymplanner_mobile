// repositories/auth_repository.dart

import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../entities/user_entity.dart';

/// Presentation katmanı SADECE bu interface'i bilir.
/// Dio, HTTP status kodları, JSON şekli — hiçbiri bu sınırın üstüne sızmaz.
abstract class AuthRepository {
  Future<Result<AuthSession>> login({
    required String loginInput,
    required String password,
  });

  Future<Result<AuthSession>> register({
    required String username,
    required String email,
    required String password,
    required String name,
    required String surname,
    String? phone,
    required DateTime birthdate,
    required Gender gender,
  });

  Future<void> logout();

  Future<UserEntity?> getCachedSession();
}
