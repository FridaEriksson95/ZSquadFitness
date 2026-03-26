import 'dart:math';
import 'package:flutter/material.dart';

/// Concrete/dots overlay for background to give a more alive feeling
class NoiseOverlay extends StatelessWidget {
  final double opacity;
  final int density;
  final int seed;

  const NoiseOverlay({
    super.key,
    this.opacity = 0.50,
    this.density = 6500,
    this.seed = 42,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _NoisePainter(
            density: density,
            seed: seed,
            opacity: opacity,
          ),
        ),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final int density;
  final int seed;
  final double opacity;

  _NoisePainter({
    required this.density,
    required this.seed,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver;

    for (int i = 0; i < density; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = rnd.nextDouble() < 0.75
          ? (rnd.nextDouble() * 0.8 + 0.14)
          : (rnd.nextDouble() * 1.35 + 0.28);

      final isLight = rnd.nextBool();
      final baseAlpha = isLight
          ? (rnd.nextDouble() * 0.18 + 0.04)
          : (rnd.nextDouble() * 0.13 + 0.02);

      paint.color = (isLight ? Colors.white : Colors.black).withValues(
        alpha: baseAlpha * opacity,
      );

      canvas.drawCircle(Offset(x, y), r, paint);
    }

    final scratchPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.28
      ..color = Colors.white.withValues(alpha: 0.11 * opacity);

    final scratchCount = max(18, (density / 260).round());
    for (int i = 0; i < scratchCount; i++) {
      final start = Offset(
        rnd.nextDouble() * size.width,
        rnd.nextDouble() * size.height,
      );
      final end =
          start +
          Offset(rnd.nextDouble() * 32 - 16, rnd.nextDouble() * 32 - 16);
      canvas.drawLine(start, end, scratchPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) {
    return oldDelegate.density != density ||
        oldDelegate.seed != seed ||
        oldDelegate.opacity != opacity;
  }
}
