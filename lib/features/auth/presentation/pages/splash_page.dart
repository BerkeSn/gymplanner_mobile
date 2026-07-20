// presentation/pages/splash_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../controllers/auth_controller.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(authControllerProvider, (
      previous,
      next,
    ) {
      try {
        next.whenOrNull(
          data: (user) {
            if (context.mounted) {
              context.go(
                user != null
                    ? AppRoutes.dashboard
                    : AppRoutes.login,
              );
            }
          },
          error: (_, __) {
            if (context.mounted)
              context.go(AppRoutes.login);
          },
        );
      } catch (error, stackTrace) {
        debugPrint(
          '[SplashPage - listen]: $error\n$stackTrace',
        );
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
