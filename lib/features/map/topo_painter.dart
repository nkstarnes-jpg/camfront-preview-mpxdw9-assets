import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lightweight topo-ish canvas: contour lines + muted greens/browns.
class TopoPainter extends CustomPainter {
  const TopoPainter({
    this.publicLandTint = true,
  });

  final bool publicLandTint;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF1A2E22);
    canvas.drawRect(Offset.zero & size, bg);

    final wash = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF243B2E),
          Color(0xFF1E2F24),
          Color(0xFF2A2418),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, wash);

    if (publicLandTint) {
      final landPaint = Paint()
        ..color = const Color(0xFF3D6B4F).withValues(alpha: 0.28)
        ..style = PaintingStyle.fill;
      final path = Path()
        ..moveTo(size.width * 0.08, size.height * 0.22)
        ..lineTo(size.width * 0.42, size.height * 0.18)
        ..lineTo(size.width * 0.55, size.height * 0.45)
        ..lineTo(size.width * 0.28, size.height * 0.58)
        ..close();
      canvas.drawPath(path, landPaint);

      final land2 = Path()
        ..moveTo(size.width * 0.58, size.height * 0.55)
        ..lineTo(size.width * 0.92, size.height * 0.48)
        ..lineTo(size.width * 0.88, size.height * 0.82)
        ..lineTo(size.width * 0.52, size.height * 0.78)
        ..close();
      canvas.drawPath(
        land2,
        Paint()..color = const Color(0xFF4A7A5C).withValues(alpha: 0.22),
      );
    }

    final contour = Paint()
      ..color = const Color(0xFF8B7355).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (var i = 0; i < 9; i++) {
      final cy = size.height * (0.12 + i * 0.095);
      final path = Path();
      path.moveTo(0, cy);
      for (var x = 0.0; x <= size.width; x += 8) {
        final y = cy +
            math.sin(x / 38 + i * 0.7) * 10 +
            math.cos(x / 55 + i) * 6;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, contour);
    }

    final creek = Paint()
      ..color = const Color(0xFF5B8FA8).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final creekPath = Path()
      ..moveTo(size.width * 0.15, 0)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.3,
        size.width * 0.4,
        size.height * 0.45,
        size.width * 0.35,
        size.height,
      );
    canvas.drawPath(creekPath, creek);
  }

  @override
  bool shouldRepaint(covariant TopoPainter oldDelegate) =>
      oldDelegate.publicLandTint != publicLandTint;
}
