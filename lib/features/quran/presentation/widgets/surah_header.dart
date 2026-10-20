import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/styles/quran_colors.dart';
import '../../../../core/styles/quran_fonts.dart';
import '../../../../core/utils/app_notifier.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../domain/models/surah_model.dart';

/// The ornamental band that opens a surah, in the manner of a printed
/// mushaf: a navy panel framed by two gold rules with a chain of diamonds
/// between them, a rosette at each end holding the surah's number and its
/// ayah count, gold lattice, and the surah's name in an ogee cartouche,
/// centred on its ink — vowel marks included — not on the font's line box.
class SurahHeader extends StatelessWidget {
  final SurahModel surah;

  /// Fits the band to one mushaf line of this height when given.
  final double? height;

  const SurahHeader({super.key, required this.surah, this.height});

  @override
  Widget build(BuildContext context) {
    final colors = context.quranColors;
    final font = context.select<AppNotifier, QuranFont>((n) => n.quranFont);
    return LayoutBuilder(
      builder: (context, box) {
        final h = height ?? 54.h;
        // The full width of the page.
        final w = box.maxWidth;
        return Center(
          child: SizedBox(
            width: w,
            height: h,
            child: CustomPaint(
              painter: _BandPainter(
                colors: colors,
                font: font,
                name: font.prepare('سُورَةُ ${surah.nameArabic}'),
                number: surah.number,
                ayahs: surah.ayahCount,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BandPainter extends CustomPainter {
  final QuranColors colors;
  final QuranFont font;
  final String name;
  final int number;
  final int ayahs;

  const _BandPainter({
    required this.colors,
    required this.font,
    required this.name,
    required this.number,
    required this.ayahs,
  });

  Color get _gold => colors.headerBorder;

  Paint _stroke(double width, [double alpha = 1]) => Paint()
    ..color = _gold.withValues(alpha: alpha)
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final band = (Offset.zero & size).deflate(h * 0.03);
    final radius = Radius.circular(h * 0.16);

    // Panel and its double frame.
    canvas.drawRRect(RRect.fromRectAndRadius(band, radius), Paint()..color = colors.headerFill);
    canvas.drawRRect(RRect.fromRectAndRadius(band, radius), _stroke(h * 0.035));
    final inner = band.deflate(h * 0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(inner, Radius.circular(h * 0.08)),
      _stroke(h * 0.016),
    );

    // A chain of small diamonds between the rules, along the long sides.
    final gap = (inner.top - band.top) / 2;
    final d = gap * 0.42;
    final chain = Paint()..color = _gold.withValues(alpha: 0.75);
    for (final y in [band.top + gap, band.bottom - gap]) {
      for (var x = band.left + h * 0.3; x < band.right - h * 0.3; x += d * 3.2) {
        canvas.drawPath(_diamond(Offset(x, y), d), chain);
      }
    }

    // The cartouche for the name.
    final cart = Rect.fromCenter(
      center: band.center,
      width: w * 0.58,
      height: inner.height * 0.92,
    );

    // Rosettes with the number and the ayah count at the ends.
    final rose = inner.height * 0.43;
    final roseL = Offset(inner.left + rose * 1.25, band.center.dy);
    final roseR = Offset(inner.right - rose * 1.25, band.center.dy);
    for (final (c, n) in [(roseR, number), (roseL, ayahs)]) {
      _rosette(canvas, c, rose);
      _text(
        canvas,
        n.toArabicDigits,
        c,
        maxWidth: rose * 1.25,
        maxHeight: rose * 0.95,
        style: TextStyle(
          color: colors.headerText,
          fontWeight: FontWeight.w700,
          fontSize: rose * (n > 99 ? 0.62 : 0.78),
        ),
      );
    }

    // Lattice between the rosettes and the cartouche.
    for (final side in [-1.0, 1.0]) {
      final from = side < 0 ? roseL.dx + rose * 1.2 : cart.right + cart.height * 0.42;
      final to = side < 0 ? cart.left - cart.height * 0.42 : roseR.dx - rose * 1.2;
      if (to - from > h * 0.3) _lattice(canvas, from, to, band.center.dy, inner.height * 0.17);
    }

    _cartouche(canvas, cart);

    // The name, centred by its ink.
    final (above, below) = font.inkExtent;
    final inkBox = cart.height * 0.86;
    _text(
      canvas,
      name,
      cart.center,
      maxWidth: cart.width - cart.height * 0.9,
      maxHeight: inkBox,
      style: TextStyle(
        fontFamily: font.family,
        color: colors.text,
        fontSize: inkBox / (above + below),
      ),
      ink: (above, below),
    );
  }

  /// Lays [text] out and paints it centred on [center], shrinking it to fit
  /// [maxWidth]. With [ink] (ems above and below the baseline) it is centred
  /// on its ink; otherwise on its line box.
  void _text(
    Canvas canvas,
    String text,
    Offset center, {
    required double maxWidth,
    required double maxHeight,
    required TextStyle style,
    (double, double)? ink,
  }) {
    var painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.rtl,
      maxLines: 1,
    )..layout();
    if (painter.width > maxWidth) {
      final scaled = style.copyWith(fontSize: style.fontSize! * maxWidth / painter.width);
      painter.dispose();
      painter = TextPainter(
        text: TextSpan(text: text, style: scaled),
        textDirection: TextDirection.rtl,
        maxLines: 1,
      )..layout();
      style = scaled;
    }
    final double top;
    if (ink != null) {
      final fs = style.fontSize!;
      final baseline = painter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
      // Midway between the top of the marks and the bottom of the kasras.
      top = center.dy + (ink.$1 - ink.$2) / 2 * fs - baseline;
    } else {
      top = center.dy - painter.height / 2;
    }
    painter.paint(canvas, Offset(center.dx - painter.width / 2, top));
    painter.dispose();
  }

  /// An ogee cartouche: a rounded panel whose ends curve in to a point,
  /// finished with a small knot, in the page colour with a double gold rule.
  void _cartouche(Canvas canvas, Rect r) {
    Path shape(Rect r) {
      final midY = r.center.dy;
      final e = r.height * 0.62; // depth of each end
      final p = Path()..moveTo(r.left + e, r.top);
      p.lineTo(r.right - e, r.top);
      p.cubicTo(r.right - e * 0.35, r.top, r.right - e * 0.55, midY - r.height * 0.06, r.right, midY);
      p.cubicTo(r.right - e * 0.55, midY + r.height * 0.06, r.right - e * 0.35, r.bottom, r.right - e, r.bottom);
      p.lineTo(r.left + e, r.bottom);
      p.cubicTo(r.left + e * 0.35, r.bottom, r.left + e * 0.55, midY + r.height * 0.06, r.left, midY);
      p.cubicTo(r.left + e * 0.55, midY - r.height * 0.06, r.left + e * 0.35, r.top, r.left + e, r.top);
      return p..close();
    }

    final outer = shape(r);
    canvas.drawPath(outer, Paint()..color = colors.pageBackground);
    canvas.drawPath(outer, _stroke(r.height * 0.05));
    canvas.drawPath(shape(r.deflate(r.height * 0.1)), _stroke(r.height * 0.018, 0.6));
    final knot = Paint()..color = _gold;
    for (final x in [r.left - r.height * 0.12, r.right + r.height * 0.12]) {
      canvas.drawPath(_diamond(Offset(x, r.center.dy), r.height * 0.1), knot);
    }
  }

  /// An eight-petalled rosette: a sixteen-point star in a ring.
  void _rosette(Canvas canvas, Offset c, double r) {
    canvas.drawPath(_star(c, r, r * 0.8, 16), Paint()..color = colors.headerFill);
    canvas.drawPath(_star(c, r, r * 0.8, 16), _stroke(r * 0.07));
    canvas.drawCircle(c, r * 0.66, _stroke(r * 0.045, 0.7));
  }

  /// A row of small eight-pointed stars linked by diamonds.
  void _lattice(Canvas canvas, double from, double to, double y, double r) {
    final step = r * 3.4;
    final count = math.max(1, ((to - from) / step).floor());
    final start = (from + to) / 2 - (count - 1) * step / 2;
    final star = Paint()..color = _gold.withValues(alpha: 0.85);
    final link = Paint()..color = _gold.withValues(alpha: 0.55);
    for (var i = 0; i < count; i++) {
      final x = start + i * step;
      canvas.drawPath(_star(Offset(x, y), r, r * 0.5, 8), star);
      if (i < count - 1) {
        canvas.drawPath(_diamond(Offset(x + step / 2, y), r * 0.35), link);
      }
    }
  }

  Path _diamond(Offset c, double r) => Path()
    ..moveTo(c.dx, c.dy - r)
    ..lineTo(c.dx + r, c.dy)
    ..lineTo(c.dx, c.dy + r)
    ..lineTo(c.dx - r, c.dy)
    ..close();

  Path _star(Offset c, double outer, double inner, int points) {
    final path = Path();
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? outer : inner;
      final a = -math.pi / 2 + i * math.pi / points;
      final p = c + Offset(math.cos(a) * r, math.sin(a) * r);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(_BandPainter old) =>
      old.colors != colors ||
      old.font != font ||
      old.name != name ||
      old.number != number ||
      old.ayahs != ayahs;
}
