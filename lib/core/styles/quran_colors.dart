import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'brand_colors.dart';

/// Mushaf colours for the active theme: an ivory page with navy ink in light
/// mode, a navy page with ivory ink in dark mode, gold ornaments in both.
@immutable
class QuranColors extends ThemeExtension<QuranColors> {
  final Color pageBackground;
  final Color text;
  final Color ayahMarker;
  final Color meta;
  final Color headerFill;
  final Color headerBorder;
  final Color headerText;

  /// Behind a selected ayah.
  final Color highlight;

  /// Behind an ayah that appears word for word elsewhere.
  final Color similarFull;

  /// Behind words an ayah shares with other ayahs.
  final Color similarPartial;

  const QuranColors({
    required this.pageBackground,
    required this.text,
    required this.ayahMarker,
    required this.meta,
    required this.headerFill,
    required this.headerBorder,
    required this.headerText,
    required this.highlight,
    required this.similarFull,
    required this.similarPartial,
  });

  static const light = QuranColors(
    pageBackground: Color(0xFFFFFDF6),
    text: Brand.navy950,
    ayahMarker: Brand.gold700,
    meta: AppColors.foregroundMuted,
    headerFill: Brand.gold100,
    headerBorder: Brand.gold600,
    headerText: Brand.navy900,
    highlight: Color(0x33C9A54A),
    similarFull: Color(0x59FFC94D),
    similarPartial: Color(0x404FC3F7),
  );

  static const dark = QuranColors(
    pageBackground: Brand.navy950,
    text: Brand.gold50,
    ayahMarker: Brand.gold400,
    meta: AppColors.foregroundSubtleDark,
    headerFill: Brand.navy800,
    headerBorder: Brand.gold500,
    headerText: Brand.gold200,
    highlight: Color(0x40C9A54A),
    similarFull: Color(0x66B8860B),
    similarPartial: Color(0x5926719C),
  );

  @override
  QuranColors copyWith({
    Color? pageBackground,
    Color? text,
    Color? ayahMarker,
    Color? meta,
    Color? headerFill,
    Color? headerBorder,
    Color? headerText,
    Color? highlight,
    Color? similarFull,
    Color? similarPartial,
  }) {
    return QuranColors(
      pageBackground: pageBackground ?? this.pageBackground,
      text: text ?? this.text,
      ayahMarker: ayahMarker ?? this.ayahMarker,
      meta: meta ?? this.meta,
      headerFill: headerFill ?? this.headerFill,
      headerBorder: headerBorder ?? this.headerBorder,
      headerText: headerText ?? this.headerText,
      highlight: highlight ?? this.highlight,
      similarFull: similarFull ?? this.similarFull,
      similarPartial: similarPartial ?? this.similarPartial,
    );
  }

  @override
  QuranColors lerp(QuranColors? other, double t) {
    if (other == null) return this;
    return QuranColors(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      text: Color.lerp(text, other.text, t)!,
      ayahMarker: Color.lerp(ayahMarker, other.ayahMarker, t)!,
      meta: Color.lerp(meta, other.meta, t)!,
      headerFill: Color.lerp(headerFill, other.headerFill, t)!,
      headerBorder: Color.lerp(headerBorder, other.headerBorder, t)!,
      headerText: Color.lerp(headerText, other.headerText, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      similarFull: Color.lerp(similarFull, other.similarFull, t)!,
      similarPartial: Color.lerp(similarPartial, other.similarPartial, t)!,
    );
  }
}

extension QuranColorsContext on BuildContext {
  QuranColors get quranColors =>
      Theme.of(this).extension<QuranColors>() ?? QuranColors.light;
}
