import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart'; // ⬅️ YENİ IMPORT
import '../../../../core/storage/secure_token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_providers.g.dart';

// ❌ SİLİNDİ: const _baseUrl = 'http://10.0.2.2:3000/api';
// ❌ SİLİNDİ: // TODO(faz2): baseUrl'i --dart-define ile env'den okuyacağız.

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl, // ⬅️ DEĞİŞTİ
      connectTimeout:
          EnvConfig.connectTimeout, // ⬅️ YENİ
      receiveTimeout:
          EnvConfig.receiveTimeout, // ⬅️ YENİ
    ),
  );
  final tokenStorage = ref.watch(
    secureTokenStorageProvider,
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await tokenStorage
              .readToken();
          if (token != null) {
            options.headers['Authorization'] =
                'Bearer $token';
          }
          handler.next(options);
        } catch (_) {
          handler.next(options);
        }
      },
    ),
  );
  return dio;
}

@riverpod
SecureTokenStorage secureTokenStorage(
  SecureTokenStorageRef ref,
) {
  return SecureTokenStorage();
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(
  AuthRemoteDataSourceRef ref,
) {
  return AuthRemoteDataSource(
    ref.watch(dioProvider),
  );
}

@riverpod
AuthRepository authRepository(
  AuthRepositoryRef ref,
) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureTokenStorageProvider),
  );
}

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  return LoginUseCase(
    ref.watch(authRepositoryProvider),
  );
}

@riverpod
RegisterUseCase registerUseCase(
  RegisterUseCaseRef ref,
) {
  return RegisterUseCase(
    ref.watch(authRepositoryProvider),
  );
}
