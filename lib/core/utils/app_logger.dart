// lib/core/utils/app_logger.dart

import 'package:flutter/foundation.dart';

/// Tüm catch bloklarında debugPrint yerine BUNU kullan.
/// Release modda otomatik susar (kDebugMode kontrolü), prod'da
/// gereksiz log sızıntısı olmaz.
class AppLogger {
  AppLogger._();

  static void error(
    String source,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      debugPrint('❌ [$source]: $error');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }

  static void info(
    String source,
    String message,
  ) {
    if (kDebugMode) {
      debugPrint('ℹ️ [$source]: $message');
    }
  }
}
