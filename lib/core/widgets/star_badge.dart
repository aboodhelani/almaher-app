import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/app_text_style.dart';
import '../utils/arabic_numbers.dart';

/// A number inside an eight-pointed star (two overlapping squares), the
/// ornament used for surah numbers.
class StarBadge extends StatelessWidget {
  final int number;
  final double? size;
  final Color? color;
  final bool filled;

  const StarBadge({
    super.key,
    required this.number,
    this.size,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final side = size ?? 40.r;
    final c = color ?? scheme.primary;
    return SizedBox(
      width: side,
      height: side,
      child: CustomPaint(
        painter: _StarPainter(color: c, filled: filled),
        child: Center(
          child: Text(
            number.toArabicDigits,
            style: AppTextStyle.small.copyWith(
              fontSize: side * (number > 99 ? 0.27 : 0.32),
              fontWeight: FontWeight.w700,
              color: filled ? scheme.surface : c,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  final bool filled;

  _StarPainter({required this.color, required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final half = size.width / 2 * 0.74;
    Path square(double angle) {
      final m = Matrix4.identity()
        ..translateByDouble(center.dx, center.dy, 0, 1)
        ..rotateZ(angle);
      return (Path()..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCircle(center: Offset.zero, radius: half),
              Radius.circular(half * 0.12),
            ),
          ))
          .transform(m.storage);
    }

    final star = Path.combine(
      PathOperation.union,
      square(0),
      square(math.pi / 4),
    );
    canvas.drawPath(
      star,
      Paint()
        ..color = color
        ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
        ..strokeWidth = size.width * 0.045
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_StarPainter old) =>
      old.color != color || old.filled != filled;
}
