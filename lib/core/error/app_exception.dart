// core/error/app_exception.dart (GÜNCELLENMİŞ)

enum AppExceptionType {
  validation,
  network,
  server,
  unexpected,
}

class AppException implements Exception {
  final String source;
  final String message;
  final AppExceptionType type;
  final Object? originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.source,
    required this.message,
    this.type = AppExceptionType.unexpected,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => '[$source]: $message';
}

/// Tekrar eden AppException oluşturma kalıplarını merkezileştirir.
class AppExceptionFactory {
  AppExceptionFactory._();

  static AppException validation({
    required String source,
    required String message,
  }) {
    return AppException(
      source: source,
      message: message,
      type: AppExceptionType.validation,
    );
  }

  static AppException network({
    required String source,
    required String message,
    Object? originalError,
    StackTrace? stackTrace,
  }) {
    return AppException(
      source: source,
      message: message,
      type: AppExceptionType.network,
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  static AppException unexpected({
    required String source,
    required Object error,
    StackTrace? stackTrace,
  }) {
    return AppException(
      source: source,
      message: 'Beklenmeyen hata: $error',
      type: AppExceptionType.unexpected,
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}

extension AppExceptionX on AppException {
  /// Kullanıcıya gösterilecek SADE mesaj — kaynak bilgisi olmadan.
  /// Ör: "Bu email zaten kayıtlı."
  String get userMessage => message;

  /// Geliştirici logu için TAM mesaj — kaynak dahil.
  /// Ör: "[AuthRemoteDataSource - register]: Bu email zaten kayıtlı."
  String get debugMessage => toString();
}
