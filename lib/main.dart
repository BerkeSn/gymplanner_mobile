import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymplanner_mobile/core/config/env_config.dart';
import 'package:gymplanner_mobile/core/locale/locale_controller.dart';
import 'package:gymplanner_mobile/core/router/app_router.dart';
import 'package:gymplanner_mobile/core/utils/app_logger.dart';

import 'core/socket/socket_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'l10n/app_localizations.dart';

void main() {
  AppLogger.info(
    'main',
    'API Base URL: ${EnvConfig.apiBaseUrl}',
  );
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
      // Kök seviyede beklenmeyen hata — kullanıcıya boş ekran yerine
      // en azından bir fallback göster.
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
