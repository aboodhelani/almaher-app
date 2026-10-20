import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A faint lattice of eight-pointed stars, laid behind hero cards and the
/// competition stage.
class StarPattern extends StatelessWidget {
  final Color color;
  final double spacing;
  final double strokeWidth;

  const StarPattern({
    super.key,
    required this.color,
    this.spacing = 44,
    this.strokeWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _StarPatternPainter(color, spacing, strokeWidth),
      ),
    );
  }
}

class _StarPatternPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double strokeWidth;

  _StarPatternPainter(this.color, this.spacing, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final r = spacing * 0.3;
    final star = Path();
    for (final angle in [0.0, math.pi / 4]) {
      final pts = List.generate(4, (i) {
        final a = angle + math.pi / 4 + i * math.pi / 2;
        return Offset(math.cos(a) * r, math.sin(a) * r);
      });
      star.addPolygon(pts, true);
    }
    var row = 0;
    for (var y = 0.0; y < size.height + spacing; y += spacing * 0.866) {
      final offset = row.isOdd ? spacing / 2 : 0.0;
      for (var x = -spacing; x < size.width + spacing; x += spacing) {
        canvas.drawPath(star.shift(Offset(x + offset, y)), paint);
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(_StarPatternPainter old) =>
      old.color != color || old.spacing != spacing;
}
