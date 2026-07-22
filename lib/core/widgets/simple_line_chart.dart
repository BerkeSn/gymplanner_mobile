import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Mockup'lardaki gradyanlı SVG trend çizgisinin Flutter karşılığı.
/// Basit tutuluyor çünkü tek ihtiyacımız trend göstermek — üçüncü parti
/// bir chart paketi (fl_chart vb.) gereksiz bağımlılık olurdu. Faz 4
/// (kalori trendi) ve Faz 6 (streak analitiği) aynı widget'ı tekrar
/// kullanacak, bu yüzden core/widgets altında.
class SimpleLineChart extends StatelessWidget {
  final List<double> values;
  final double height;

  const SimpleLineChart({
    super.key,
    required this.values,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if (values.length < 2) {
        return SizedBox(
          height: height,
          child: Center(
            child: Text(
              'Trend için en az 2 veri noktası gerekiyor.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium,
            ),
          ),
        );
      }
      return SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _LineChartPainter(
            values: values,
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[SimpleLineChart - build]: $error\n$stackTrace',
      );
      return SizedBox(height: height);
    }
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  _LineChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    try {
      final minValue = values.reduce(
        (a, b) => a < b ? a : b,
      );
      final maxValue = values.reduce(
        (a, b) => a > b ? a : b,
      );
      // Tüm değerler eşitse (örn. tek antrenman tekrar edilmiş) sıfıra
      // bölmeyi önlemek için küçük bir aralık varsayıyoruz.
      final range =
          (maxValue - minValue).abs() < 0.001
          ? 1.0
          : (maxValue - minValue);

      final stepX =
          size.width / (values.length - 1);
      final points = <Offset>[];
      for (var i = 0; i < values.length; i++) {
        final normalized =
            (values[i] - minValue) / range;
        final y =
            size.height -
            (normalized * size.height * 0.85) -
            8;
        points.add(Offset(i * stepX, y));
      }

      final linePath = Path()
        ..moveTo(
          points.first.dx,
          points.first.dy,
        );
      for (var i = 1; i < points.length; i++) {
        final prev = points[i - 1];
        final current = points[i];
        final controlPoint1 = Offset(
          (prev.dx + current.dx) / 2,
          prev.dy,
        );
        final controlPoint2 = Offset(
          (prev.dx + current.dx) / 2,
          current.dy,
        );
        linePath.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          current.dx,
          current.dy,
        );
      }

      // Gradyan dolgu (mockup'taki "area under curve" hissi).
      final fillPath = Path.from(linePath)
        ..lineTo(points.last.dx, size.height)
        ..lineTo(points.first.dx, size.height)
        ..close();

      final fillPaint = Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withValues(
                  alpha: 0.18,
                ),
                AppColors.primary.withValues(
                  alpha: 0.0,
                ),
              ],
            ).createShader(
              Rect.fromLTWH(
                0,
                0,
                size.width,
                size.height,
              ),
            );
      canvas.drawPath(fillPath, fillPaint);

      final linePaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(linePath, linePaint);

      // Son noktayı vurgula (mockup'taki nabız noktası).
      canvas.drawCircle(
        points.last,
        5,
        Paint()..color = AppColors.primary,
      );
      canvas.drawCircle(
        points.last,
        8,
        Paint()
          ..color = AppColors.primary.withValues(
            alpha: 0.25,
          ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[_LineChartPainter - paint]: $error\n$stackTrace',
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _LineChartPainter oldDelegate,
  ) {
    return oldDelegate.values != values;
  }
}
