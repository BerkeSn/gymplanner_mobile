// core/widgets/weekly_bar_chart.dart (yeni dosya)

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Haftaya bölünmüş bar grafik — "hangi hafta düşmüş" sorusuna cevap
/// verir. SimpleLineChart'tan farklı olarak X ekseninde etiket taşır.
class WeeklyBarChart extends StatelessWidget {
  final List<({String label, double value})>
  weeks;
  final double height;

  const WeeklyBarChart({
    super.key,
    required this.weeks,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    if (weeks.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('Veri yok.'),
        ),
      );
    }
    final maxValue = weeks
        .map((w) => w.value)
        .reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end,
        children: weeks.map((week) {
          final heightFactor = maxValue > 0
              ? (week.value / maxValue)
              : 0.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  Text(
                    week.value.toStringAsFixed(0),
                    style: AppTextStyles
                        .labelSmall
                        .copyWith(fontSize: 9),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height:
                        (height - 44) *
                        heightFactor.clamp(
                          0.05,
                          1.0,
                        ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          const BorderRadius.vertical(
                            top: Radius.circular(
                              4,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    week.label,
                    style: AppTextStyles
                        .labelSmall
                        .copyWith(fontSize: 9),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
