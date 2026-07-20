import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymplanner_mobile/features/exercise/presentation/pages/exercise_library_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_step1_page.dart';
import '../../features/auth/presentation/pages/signup_step2_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_dashboard_page.dart';
import '../widgets/app_shell.dart';
import '../widgets/placeholder_page.dart';

part 'app_router.g.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const login = '/login';
  static const signupStep1 = '/signup/step-1';
  static const signupStep2 = '/signup/step-2';

  // Bottom nav sekmeleri — StatefulShellRoute branch'leri
  static const dashboard = '/dashboard';
  static const nutrition = '/nutrition';
  static const insights = '/insights';
  static const fitness = '/fitness';
  static const profile = '/profile';
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  try {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.signupStep1,
          builder: (context, state) => const SignupStep1Page(),
        ),
        GoRoute(
          path: AppRoutes.signupStep2,
          builder: (context, state) => const SignupStep2Page(),
        ),

        // ⬇️ YENİ: Bottom nav shell — 5 bağımsız sekme
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.nutrition,
                  builder: (context, state) => const PlaceholderPage(
                    title: 'Beslenme',
                    icon: Icons.restaurant_outlined,
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.dashboard,
                  builder: (context, state) => const HomeDashboardPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.insights,
                  builder: (context, state) => const PlaceholderPage(
                    title: 'Analiz',
                    icon: Icons.insights_outlined,
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.fitness,
                  builder: (context, state) =>
                      const ExerciseLibraryPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.profile,
                  builder: (context, state) => const PlaceholderPage(
                    title: 'Profil',
                    icon: Icons.person_outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  } catch (error, stackTrace) {
    throw Exception('[app_router - appRouter]: ${error.toString()}\n$stackTrace');
  }
}