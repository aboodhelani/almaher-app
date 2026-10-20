import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_font_size.dart';

class AppTextStyle {
  /// Interface text. The Quran keeps [quranFont].
  static const uiFont = 'IBMPlexSansArabic';
  static const quranFont = 'AmiriQuran';

  static TextStyle _ui(double size, [FontWeight weight = FontWeight.w400]) =>
      TextStyle(
        fontFamily: uiFont,
        fontSize: size,
        color: AppColors.foreground,
        fontWeight: weight,
        height: 1.45,
      );

  static TextStyle xSmall = _ui(AppFontSize.xSmall);
  static TextStyle small = _ui(AppFontSize.small);
  static TextStyle medium = _ui(AppFontSize.medium);
  static TextStyle large = _ui(AppFontSize.large);
  static TextStyle xLarge = _ui(AppFontSize.xLarge);
  static TextStyle xxLarge = _ui(AppFontSize.xxLarge);
  static TextStyle xxxLarge = _ui(AppFontSize.xxxLarge);
  static TextStyle xxxxxLarge = _ui(AppFontSize.xxxxxLarge);

  /// Big numbers: scores, the countdown, match IDs.
  static TextStyle display = _ui(
    AppFontSize.display,
    FontWeight.w700,
  ).copyWith(height: 1.1);

  // Quran — colours come from QuranColors (context.quranColors).
  static TextStyle quranAyah = TextStyle(
    fontFamily: quranFont,
    fontSize: AppFontSize.quran,
    height: 2.1,
  );

  static TextStyle quranSurahTitle = TextStyle(
    fontFamily: quranFont,
    fontSize: AppFontSize.xxLarge,
    height: 1.6,
  );

  static TextStyle quranBasmala = quranAyah.copyWith(height: 1.8);

  static TextStyle quranPageMeta = TextStyle(
    fontFamily: quranFont,
    fontSize: AppFontSize.medium,
  );
}
