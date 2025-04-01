import 'package:flutter/material.dart';
import 'dart:math' as math;

class SciFiBackground extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final double gridSize;
  final double lineWidth;
  final double glowIntensity;
  final List<Offset>? customPoints;
  final List<Color>? gradientColors;
  final Widget? child;

  const SciFiBackground({
    super.key,
    this.primaryColor = const Color(0xFF1A1A2E),
    this.secondaryColor = const Color(0xFF16213E),
    this.accentColor = const Color(0xFF0F3460),
    this.gridSize = 30,
    this.lineWidth = 1,
    this.glowIntensity = 0.5,
    this.customPoints,
    this.gradientColors,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 基礎背景
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors ?? [
                primaryColor,
                secondaryColor,
                accentColor,
              ],
            ),
          ),
        ),
        // 網格和特效
        CustomPaint(
          painter: SciFiBackgroundPainter(
            gridSize: gridSize,
            lineWidth: lineWidth,
            glowIntensity: glowIntensity,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            accentColor: accentColor,
            customPoints: customPoints,
          ),
          child: Container(),
        ),
        // 內容
        if (child != null) child!,
      ],
    );
  }
}

class SciFiBackgroundPainter extends CustomPainter {
  final double gridSize;
  final double lineWidth;
  final double glowIntensity;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final List<Offset>? customPoints;

  SciFiBackgroundPainter({
    required this.gridSize,
    required this.lineWidth,
    required this.glowIntensity,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.customPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.3)
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // 繪製網格
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // 繪製六邊形網格
    _drawHexagonGrid(canvas, size);

    // 繪製發光點
    _drawGlowPoints(canvas, size);

    // 繪製自定義點
    if (customPoints != null) {
      _drawCustomPoints(canvas);
    }
  }

  void _drawHexagonGrid(Canvas canvas, Size size) {
    final hexSize = gridSize / 2;
    final paint = Paint()
      ..color = secondaryColor.withOpacity(0.2)
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    for (double y = 0; y < size.height; y += hexSize * 1.5) {
      for (double x = 0; x < size.width; x += hexSize * math.sqrt(3)) {
        _drawHexagon(canvas, Offset(x, y), hexSize, paint);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final point = Offset(
        center.dx + size * math.cos(angle),
        center.dy + size * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawGlowPoints(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 10; i++) {
      final x = math.Random().nextDouble() * size.width;
      final y = math.Random().nextDouble() * size.height;
      final radius = math.Random().nextDouble() * 3 + 1;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawCustomPoints(Canvas canvas) {
    if (customPoints == null) return;

    final paint = Paint()
      ..color = accentColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (final point in customPoints!) {
      canvas.drawCircle(point, 2, paint);
    }
  }

  @override
  bool shouldRepaint(SciFiBackgroundPainter oldDelegate) {
    return gridSize != oldDelegate.gridSize ||
           lineWidth != oldDelegate.lineWidth ||
           glowIntensity != oldDelegate.glowIntensity ||
           primaryColor != oldDelegate.primaryColor ||
           secondaryColor != oldDelegate.secondaryColor ||
           accentColor != oldDelegate.accentColor ||
           customPoints != oldDelegate.customPoints;
  }
} 