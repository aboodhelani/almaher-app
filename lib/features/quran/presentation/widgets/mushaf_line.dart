import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../../../core/styles/quran_colors.dart';
import '../../../../core/styles/quran_fonts.dart';
import '../../../mutashabihat/domain/models/mutashabihat_model.dart';
import '../../../tajweed/domain/models/tajweed_model.dart';
import '../../../tajweed/domain/models/tajweed_span_model.dart';
import '../../../tajweed/presentation/widgets/tajweed_text.dart';
import '../../domain/models/ayah_model.dart';
import '../../domain/models/mushaf_line_model.dart';
import 'sajda_words.dart';

/// What the page needs to colour and mark a line.
class MushafLineStyle {
  final QuranFont font;
  final double fontSize;
  final QuranColors colors;
  final Brightness brightness;
  final String? highlightedAyahKey;
  final TajweedModel? tajweed;
  final MutashabihatModel? mutashabihat;

  const MushafLineStyle({
    required this.font,
    required this.fontSize,
    required this.colors,
    required this.brightness,
    required this.highlightedAyahKey,
    required this.tajweed,
    required this.mutashabihat,
  });

  TextStyle get base => TextStyle(
    fontFamily: font.family,
    fontSize: fontSize,
    color: colors.text,
  );
}

/// A line's spans, which ayah each character belongs to, and where the
/// sajda line goes.
class _LineSpans {
  final List<InlineSpan> spans = [];
  final List<(int, int, AyahModel)> ayahs = [];
  final List<(int, int)> sajda = [];
  var length = 0;
  var gaps = 0;

  void add(InlineSpan span, String text, AyahModel? ayah) {
    spans.add(span);
    if (ayah != null) ayahs.add((length, length + text.length, ayah));
    length += text.length;
    gaps += ' '.allMatches(text).length;
  }
}

_LineSpans _buildSpans(TextLine line, MushafLineStyle style) {
  final out = _LineSpans();
  final colors = style.colors;
  for (final seg in line.segments) {
    final ayah = seg.ayah;
    final (start, end) = seg.charRange;
    final highlighted = ayah.key == style.highlightedAyahKey;
    if (out.length > 0 && end > start) {
      out.add(TextSpan(text: ' ', style: style.base), ' ', null);
    }
    if (end > start) {
      final similarity = style.mutashabihat?.forAyah(ayah.key);
      final text = style.font.prepare(ayah.text.substring(start, end));
      // Tajweed and similarity ranges are per ayah: shift them to the piece.
      final tajweed = [
        for (final s in style.tajweed?.forAyah(ayah.key) ?? <TajweedSpanModel>[])
          if (s.end > start && s.start < end)
            TajweedSpanModel(
              start: (s.start - start).clamp(0, text.length),
              end: (s.end - start).clamp(0, text.length),
              rule: s.rule,
            ),
      ];
      final backgrounds = highlighted || similarity == null
          ? const <(int, int, Color)>[]
          : similarity.fullMatch
          ? [(0, text.length, colors.similarFull)]
          : [
              for (final (a, b) in similarity.partialRanges)
                if (b > start && a < end)
                  (
                    (a - start).clamp(0, text.length),
                    (b - start).clamp(0, text.length),
                    colors.similarPartial,
                  ),
            ];
      final sajda = sajdaRange(ayah);
      if (sajda != null && sajda.$2 > start && sajda.$1 < end) {
        out.sajda.add((
          out.length + (sajda.$1 - start).clamp(0, text.length),
          out.length + (sajda.$2 - start).clamp(0, text.length),
        ));
      }
      out.add(
        TextSpan(
          children: tajweedTextSpans(
            text,
            tajweed,
            style.base.copyWith(
              backgroundColor: highlighted ? colors.highlight : null,
            ),
            style.brightness,
            backgrounds: backgrounds,
          ),
        ),
        text,
        ayah,
      );
    }
    if (seg.endsAyah) {
      final marker =
          '${out.length > 0 ? ' ' : ''}${style.font.ayahMarker(ayah.numberInSurah)}';
      out.add(
        TextSpan(
          text: marker,
          style: style.base.copyWith(color: colors.ayahMarker),
        ),
        marker,
        ayah,
      );
    }
  }
  return out;
}

/// The natural width of [line] in [style] (to fit the page's font size).
double measureMushafLine(TextLine line, MushafLineStyle style) {
  final painter = TextPainter(
    text: TextSpan(style: style.base, children: _buildSpans(line, style).spans),
    textDirection: TextDirection.rtl,
    maxLines: 1,
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}

/// One printed line, stretched across [width] as the mushaf justifies it
/// (unless [justify] is off, as on the first two pages). Tap and long press
/// report the ayah under the finger.
class MushafTextLine extends StatefulWidget {
  final TextLine line;
  final MushafLineStyle style;
  final double width;
  final bool justify;
  final ValueChanged<AyahModel?> onTap;
  final ValueChanged<AyahModel> onLongPress;

  const MushafTextLine({
    super.key,
    required this.line,
    required this.style,
    required this.width,
    required this.justify,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<MushafTextLine> createState() => _MushafTextLineState();
}

class _MushafTextLineState extends State<MushafTextLine> {
  final _textKey = GlobalKey();
  List<Rect> _sajdaBoxes = const [];
  late _LineSpans _spans;

  RenderParagraph? get _paragraph {
    final p = _textKey.currentContext?.findRenderObject();
    return p is RenderParagraph && p.hasSize ? p : null;
  }

  /// The ayah with a glyph at [position] (this widget's coordinates).
  AyahModel? _ayahAt(Offset position) {
    final paragraph = _paragraph;
    if (paragraph == null) return null;
    final local = paragraph.globalToLocal(
      (context.findRenderObject() as RenderBox).localToGlobal(position),
    );
    final offset = paragraph.getPositionForOffset(local).offset;
    for (final (start, end, ayah) in _spans.ayahs) {
      if (offset < start || offset > end) continue;
      final boxes = paragraph.getBoxesForSelection(
        TextSelection(baseOffset: start, extentOffset: end),
      );
      if (boxes.any((b) => b.toRect().inflate(2).contains(local))) return ayah;
    }
    return null;
  }

  /// Where the sajda words sit, once laid out.
  void _measureSajda() {
    final paragraph = _paragraph;
    if (!mounted || paragraph == null) return;
    final boxes = [
      for (final (start, end) in _spans.sajda)
        for (final box in paragraph.getBoxesForSelection(
          TextSelection(baseOffset: start, extentOffset: end),
        ))
          box.toRect(),
    ];
    if (boxes.length != _sajdaBoxes.length ||
        Iterable.generate(boxes.length).any((i) => boxes[i] != _sajdaBoxes[i])) {
      setState(() => _sajdaBoxes = boxes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    _spans = _buildSpans(widget.line, style);
    final natural = measureMushafLine(widget.line, style);
    final spare = widget.width - natural;
    // Justify by widening the spaces, as the printed lines are.
    final wordSpacing = widget.justify && spare > 0 && _spans.gaps > 0
        ? spare / _spans.gaps
        : 0.0;
    if (_spans.sajda.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureSajda());
    }
    final text = Text.rich(
      key: _textKey,
      TextSpan(
        style: style.base.copyWith(wordSpacing: wordSpacing),
        children: _spans.spans,
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      maxLines: 1,
      softWrap: false,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) => widget.onTap(_ayahAt(d.localPosition)),
      onLongPressStart: (d) {
        final ayah = _ayahAt(d.localPosition);
        if (ayah == null) return;
        HapticFeedback.selectionClick();
        widget.onLongPress(ayah);
      },
      child: SizedBox(
        width: widget.width,
        child: FittedBox(
          // A line a touch wider than the page shrinks rather than clips.
          fit: BoxFit.scaleDown,
          child: CustomPaint(
            foregroundPainter: _sajdaBoxes.isEmpty
                ? null
                : _SajdaLinePainter(_sajdaBoxes, style.colors.text),
            child: text,
          ),
        ),
      ),
    );
  }
}

/// The line over a sajda's words, just above the letters.
class _SajdaLinePainter extends CustomPainter {
  final List<Rect> boxes;
  final Color color;

  const _SajdaLinePainter(this.boxes, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.3;
    for (final box in boxes) {
      final y = box.top + box.height * 0.12;
      canvas.drawLine(Offset(box.left, y), Offset(box.right, y), paint);
    }
  }

  @override
  bool shouldRepaint(_SajdaLinePainter old) =>
      old.boxes != boxes || old.color != color;
}
