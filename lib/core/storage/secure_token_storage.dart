// lib/core/storage/secure_token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../error/app_exception.dart';

class SecureTokenStorage {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage;

  SecureTokenStorage({
    FlutterSecureStorage? storage,
  }) : _storage =
           storage ??
           const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(
        key: _tokenKey,
        value: token,
      );
    } catch (error, stackTrace) {
      throw AppException(
        source: 'SecureTokenStorage - saveToken',
        message: 'Token kaydedilemedi: $error',
        originalError: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<String?> readToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (error, stackTrace) {
      throw AppException(
        source: 'SecureTokenStorage - readToken',
        message: 'Token okunamadı: $error',
        originalError: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (error, stackTrace) {
      throw AppException(
        source: 'SecureTokenStorage - clearToken',
        message: 'Token silinemedi: $error',
        originalError: error,
        stackTrace: stackTrace,
      );
    }
  }
}
