// lib/core/widgets/exercise_placeholder_thumbnail.dart

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Gerçek egzersiz görselleri Faz 7'de (medya upload altyapısı) bağlanana
/// kadar, "fotoğraf varmış gibi" hissettiren stilize bir placeholder.
/// imageUrl dolduğunda otomatik gerçek görsele geçer — interface hiç
/// değişmez, çağıran taraflar tek satır bile güncellemez.
class ExercisePlaceholderThumbnail
    extends StatelessWidget {
  final String? imageUrl;
  final String muscleGroupName;
  final double size;

  const ExercisePlaceholderThumbnail({
    super.key,
    required this.imageUrl,
    required this.muscleGroupName,
    this.size = 64,
  });

  /// Kas grubuna göre sabit bir gradyan seçer (hash tabanlı, deterministik) —
  /// aynı kas grubundaki egzersizler görsel olarak "aile" hissi verir.
  List<Color> _gradientFor(
    String muscleGroupName,
  ) {
    final palettes = <List<Color>>[
      [
        AppColors.primary,
        AppColors.primaryContainer,
      ],
      [
        AppColors.tertiary,
        AppColors.tertiaryContainer,
      ],
      [
        AppColors.secondary,
        AppColors.surfaceContainerHigh,
      ],
    ];
    final index =
        muscleGroupName.hashCode.abs() %
        palettes.length;
    return palettes[index];
  }

  @override
  Widget build(BuildContext context) {
    try {
      final hasRealImage =
          imageUrl != null &&
          imageUrl!.isNotEmpty;

      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: size,
          height: size,
          child: hasRealImage
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _placeholder(),
                )
              : _placeholder(),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[ExercisePlaceholderThumbnail - build]: $error\n$stackTrace',
      );
      return SizedBox(width: size, height: size);
    }
  }

  Widget _placeholder() {
    final colors = _gradientFor(muscleGroupName);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.fitness_center,
          color: Colors.white.withValues(
            alpha: 0.9,
          ),
          size: size * 0.4,
        ),
      ),
    );
  }
}

/// ScheduleExerciseSheet gibi "hero" alan gerektiren ekranlarda kullanılan,
/// tam genişlikte büyük placeholder. Aynı gradyan hesaplama mantığını
/// ExercisePlaceholderThumbnail ile paylaşır (aynı egzersiz = aynı renk).
class ExercisePlaceholderHero
    extends StatelessWidget {
  final String? imageUrl;
  final String muscleGroupName;
  final double height;

  const ExercisePlaceholderHero({
    super.key,
    required this.imageUrl,
    required this.muscleGroupName,
    required this.height,
  });

  List<Color> _gradientFor(
    String muscleGroupName,
  ) {
    final palettes = <List<Color>>[
      [
        AppColors.primary,
        AppColors.primaryContainer,
      ],
      [
        AppColors.tertiary,
        AppColors.tertiaryContainer,
      ],
      [
        AppColors.secondary,
        AppColors.surfaceContainerHigh,
      ],
    ];
    final index =
        muscleGroupName.hashCode.abs() %
        palettes.length;
    return palettes[index];
  }

  @override
  Widget build(BuildContext context) {
    try {
      final hasRealImage =
          imageUrl != null &&
          imageUrl!.isNotEmpty;

      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: hasRealImage
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _placeholder(),
                )
              : _placeholder(),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[ExercisePlaceholderHero - build]: $error\n$stackTrace',
      );
      return SizedBox(
        width: double.infinity,
        height: height,
      );
    }
  }

  Widget _placeholder() {
    final colors = _gradientFor(muscleGroupName);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(
                      alpha: 0.25,
                    ),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.fitness_center,
              color: Colors.white.withValues(
                alpha: 0.9,
              ),
              size: height * 0.28,
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Hareket Tekniği',
                  style: TextStyle(
                    color: Colors.white
                        .withValues(alpha: 0.95),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
