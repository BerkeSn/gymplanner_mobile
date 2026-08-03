import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// GPS koordinatlarını (lat/lng) gerçek harita olmadan, stilize bir çizgi
/// olarak çizer. SimpleLineChart ile aynı felsefe: üçüncü parti harita
/// SDK'sına ihtiyaç duymadan, gerçek veriye dayalı bir görsel sunar.
class RoutePathPreview extends StatelessWidget {
  final List<({double lat, double lng})> points;
  final double height;

  const RoutePathPreview({
    super.key,
    required this.points,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    try {
      if (points.length < 2) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.route,
              color: AppColors.outline,
            ),
          ),
        );
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: height,
          width: double.infinity,
          color: AppColors.surfaceContainerHigh,
          child: CustomPaint(
            painter: _RoutePainter(
              points: points,
            ),
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[RoutePathPreview - build]: $error\n$stackTrace',
      );
      return SizedBox(height: height);
    }
  }
}

class _RoutePainter extends CustomPainter {
  final List<({double lat, double lng})> points;
  _RoutePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    try {
      final lats = points
          .map((p) => p.lat)
          .toList();
      final lngs = points
          .map((p) => p.lng)
          .toList();
      final minLat = lats.reduce(
        (a, b) => a < b ? a : b,
      );
      final maxLat = lats.reduce(
        (a, b) => a > b ? a : b,
      );
      final minLng = lngs.reduce(
        (a, b) => a < b ? a : b,
      );
      final maxLng = lngs.reduce(
        (a, b) => a > b ? a : b,
      );

      final latRange =
          (maxLat - minLat).abs() < 0.00001
          ? 1.0
          : (maxLat - minLat);
      final lngRange =
          (maxLng - minLng).abs() < 0.00001
          ? 1.0
          : (maxLng - minLng);

      const padding = 24.0;
      final offsets = points.map((p) {
        final x =
            padding +
            ((p.lng - minLng) / lngRange) *
                (size.width - padding * 2);
        // Lat ekseni ters (haritada yukarı = artan enlem, canvas'ta yukarı = azalan y).
        final y =
            padding +
            (1 - (p.lat - minLat) / latRange) *
                (size.height - padding * 2);
        return Offset(x, y);
      }).toList();

      final path = Path()
        ..moveTo(
          offsets.first.dx,
          offsets.first.dy,
        );
      for (var i = 1; i < offsets.length; i++) {
        path.lineTo(offsets[i].dx, offsets[i].dy);
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      // Başlangıç ve bitiş noktaları.
      canvas.drawCircle(
        offsets.first,
        6,
        Paint()..color = AppColors.secondary,
      );
      canvas.drawCircle(
        offsets.last,
        7,
        Paint()..color = AppColors.primary,
      );
      canvas.drawCircle(
        offsets.last,
        11,
        Paint()
          ..color = AppColors.primary.withValues(
            alpha: 0.25,
          ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[_RoutePainter - paint]: $error\n$stackTrace',
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _RoutePainter oldDelegate,
  ) => oldDelegate.points != points;
}
