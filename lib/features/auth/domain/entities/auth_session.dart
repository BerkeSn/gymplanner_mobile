// entities/auth_session.dart

import 'user_entity.dart';

/// Login/register sonrası dönen birleşik sonuç: token + kullanıcı.
class AuthSession {
  final String token;
  final UserEntity user;

  const AuthSession({
    required this.token,
    required this.user,
  });
}
