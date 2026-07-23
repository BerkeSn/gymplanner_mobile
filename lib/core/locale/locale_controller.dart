import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/app_preferences.dart';
import '../utils/app_logger.dart';

part 'locale_controller.g.dart';

/// Uygulama genelinde seçili dili yönetir, SharedPreferences ile kalıcı
/// hale getirir. keepAlive: true — kullanıcı hangi ekranda olursa olsun
/// dil tercihi bellekte kalmalı, autoDispose ile kaybolmamalı.
@Riverpod(keepAlive: true)
class LocaleController
    extends _$LocaleController {
  static const _prefsKey = 'app_locale_code';
  static const _supportedCodes = ['tr', 'en'];

  @override
  FutureOr<Locale> build() async {
    return _loadSavedOrDeviceLocale();
  }

  Future<Locale>
  _loadSavedOrDeviceLocale() async {
    try {
      final prefs = await ref.watch(
        sharedPreferencesProvider.future,
      );
      final savedCode = prefs.getString(
        _prefsKey,
      );
      if (savedCode != null &&
          _supportedCodes.contains(savedCode)) {
        return Locale(savedCode);
      }

      // Kayıtlı tercih yoksa cihaz dilini dene, desteklemiyorsak TR'ye düş.
      final deviceCode = PlatformDispatcher
          .instance
          .locale
          .languageCode;
      return _supportedCodes.contains(deviceCode)
          ? Locale(deviceCode)
          : const Locale('tr');
    } catch (error, stackTrace) {
      AppLogger.error(
        'LocaleController - _loadSavedOrDeviceLocale',
        error,
        stackTrace,
      );
      return const Locale('tr');
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      state = AsyncData(locale);
      final prefs = await ref.read(
        sharedPreferencesProvider.future,
      );
      await prefs.setString(
        _prefsKey,
        locale.languageCode,
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'LocaleController - setLocale',
        error,
        stackTrace,
      );
    }
  }

  Future<void> toggleLocale() async {
    final current =
        state.valueOrNull ?? const Locale('tr');
    final next = current.languageCode == 'tr'
        ? const Locale('en')
        : const Locale('tr');
    await setLocale(next);
  }
}
