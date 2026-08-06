import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../utils/app_logger.dart';

/// StatefulShellRoute'un builder'ına verilen ana iskelet.
/// navigationShell her sekmenin KENDİ bağımsız state'ini taşır —
/// sekmeler arası geçişte scroll pozisyonu, form verisi vb. kaybolmaz.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationTap(int index) {
    try {
      navigationShell.goBranch(
        index,
        // Aynı sekmeye tekrar basılırsa o sekmenin kök route'una döner
        // (örn. Profil sekmesinde derine inmişken tekrar Profil'e basınca).
        initialLocation:
            index == navigationShell.currentIndex,
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'AppShell - _onDestinationTap',
        error,
        stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex:
              navigationShell.currentIndex,
          onDestinationSelected:
              _onDestinationTap,
          backgroundColor:
              AppColors.surfaceContainerLowest,
          indicatorColor: AppColors.primary
              .withValues(alpha: 0.12),
          height: 64,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.restaurant_outlined,
              ),
              selectedIcon: Icon(
                Icons.restaurant,
              ),
              label: 'Beslenme',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: 'Analiz',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.fitness_center_outlined,
              ),
              selectedIcon: Icon(
                Icons.fitness_center,
              ),
              label: 'Antrenman',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'AppShell - build',
        error,
        stackTrace,
      );
      return Scaffold(body: navigationShell);
    }
  }
}
