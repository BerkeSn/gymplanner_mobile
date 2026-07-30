// lib/core/config/env_config.dart

/// Ortam değişkenlerini tek noktadan yönetir.
/// Değerler `flutter run --dart-define=API_BASE_URL=...` ile enjekte edilir,
/// koda asla hardcode edilmez — böylece dev/staging/prod arasında
/// TEK SATIR bile kod değiştirmeden geçiş yaparız.
class EnvConfig {
  EnvConfig._();

  /// Render'daki backend'in kök adresi + /api prefix'i.
  /// --dart-define verilmezse local geliştirme için Android emulator
  /// localhost adresine (10.0.2.2) düşer.
  /// 
  static const String apiBaseUrl =
      String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://gymplanner-0ppj.onrender.com/api',
      );

  static String get socketBaseUrl {
    return apiBaseUrl.endsWith('/api')
        ? apiBaseUrl.substring(
            0,
            apiBaseUrl.length - 4,
          )
        : apiBaseUrl;
  }

  static const Duration connectTimeout = Duration(
    seconds: 90,
  );
  static const Duration receiveTimeout = Duration(
    seconds: 90,
  );
}
