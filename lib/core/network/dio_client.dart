// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';

import '../error/app_exception.dart';
import '../storage/secure_token_storage.dart';

class DioClient {
  final Dio dio;
  final SecureTokenStorage _tokenStorage;

  DioClient(this._tokenStorage, {required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await _tokenStorage.readToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          } catch (error, stackTrace) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: AppException(
                  source: 'DioClient - onRequest',
                  message: 'Token eklenirken hata oluştu: $error',
                  originalError: error,
                  stackTrace: stackTrace,
                ),
              ),
            );
          }
        },
        onError: (DioException error, handler) {
          // Backend'imiz { success: false, message/error } şeklinde dönüyor,
          // burada tek noktadan normalize ediyoruz.
          final serverMessage = error.response?.data is Map
              ? (error.response?.data['message'] ??
                  error.response?.data['error'])
              : null;

          final wrapped = AppException(
            source: 'DioClient - onError',
            message: serverMessage?.toString() ??
                error.message ??
                'Bilinmeyen ağ hatası',
            originalError: error,
            stackTrace: error.stackTrace,
          );

          handler.next(error.copyWith(error: wrapped));
        },
      ),
    );
  }
}