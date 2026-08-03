import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/locale/locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/socket/socket_service.dart';
import 'core/theme/app_colors.dart'; // ⬅️ YENİ
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_controller.dart'; // ⬅️ YENİ
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(
    const ProviderScope(child: GymPlannerApp()),
  );
}

class GymPlannerApp extends ConsumerWidget {
  const GymPlannerApp({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    try {
      final router = ref.watch(appRouterProvider);
      final localeAsync = ref.watch(
        localeControllerProvider,
      );
      final currentLocale =
          localeAsync.valueOrNull ??
          const Locale('tr');

      // ⬇️ YENİ: Kullanıcının seçtiği ThemeMode'u oku. ThemeMode.system
      // seçiliyse cihazın o anki parlaklığını (MediaQuery) kullanıyoruz —
      // AppColors.setBrightness çağrısı MaterialApp döndürülmeden ÖNCE
      // yapılmalı ki bu frame'de build edilecek widget'lar doğru paleti okusun.
      final themeModeAsync = ref.watch(
        themeModeControllerProvider,
      );
      final themeMode =
          themeModeAsync.valueOrNull ??
          ThemeMode.system;
      final platformBrightness =
          MediaQuery.platformBrightnessOf(
            context,
          );
      final effectiveBrightness =
          switch (themeMode) {
            ThemeMode.light => Brightness.light,
            ThemeMode.dark => Brightness.dark,
            ThemeMode.system =>
              platformBrightness,
          };
      AppColors.setBrightness(
        effectiveBrightness,
      );

      ref.listen(authControllerProvider, (
        previous,
        next,
      ) {
        try {
          final socketService = ref.read(
            socketServiceProvider,
          );
          final user = next.valueOrNull;
          if (user != null) {
            socketService.connect(user.id);
          } else {
            socketService.disconnect();
          }
        } catch (error, stackTrace) {
          debugPrint(
            '[main - authControllerProvider listener]: $error\n$stackTrace',
          );
        }
      });

      return MaterialApp.router(
        title: 'GymPlanner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: router,
        locale: currentLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr'),
          Locale('en'),
        ],
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[GymPlannerApp - build]: $error\n$stackTrace',
      );
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Uygulama başlatılamadı: $error',
            ),
          ),
        ),
      );
    }
  }
}
