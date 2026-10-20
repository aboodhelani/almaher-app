import 'package:flutter/material.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/quran_colors.dart';
import '../../domain/models/tajweed_span_model.dart';
import 'tajweed_text.dart';

/// The word(s) of [ayahText] that [span] falls in, with only that span
/// coloured — "where" a rule happens.
class TajweedWord extends StatelessWidget {
  final String ayahText;
  final TajweedSpanModel span;
  final double fontSize;

  const TajweedWord({
    super.key,
    required this.ayahText,
    required this.span,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final from =
        ayahText.lastIndexOf(' ', (span.start - 1).clamp(0, ayahText.length)) +
        1;
    var to = ayahText.indexOf(' ', span.end.clamp(0, ayahText.length));
    if (to < 0) to = ayahText.length;
    final word = ayahText.substring(from, to);
    final local = TajweedSpanModel(
      start: span.start - from,
      end: span.end - from,
      rule: span.rule,
    );

    return Text.rich(
      TextSpan(
        children: tajweedTextSpans(
          word,
          [local],
          AppTextStyle.quranAyah.copyWith(
            fontSize: fontSize,
            height: 1.6,
            color: context.quranColors.text,
          ),
          Theme.of(context).brightness,
        ),
      ),
      textDirection: TextDirection.rtl,
    );
  }
}
