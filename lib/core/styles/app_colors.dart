import 'package:flutter/material.dart';

import 'brand_colors.dart';

/// Reading side of the app in the brand's navy and gold: an ivory page and
/// navy ink by day, a navy page and ivory ink by night, gold for selection,
/// highlights and active controls. The competition has its own palette (see
/// GameColors). Red is for errors only.
class AppColors {
  // Accent
  static const accent = Brand.navy800;
  static const accentSoft = Brand.gold100;
  static const accentDark = Brand.gold500;
  static const accentSoftDark = Brand.navy700;

  /// Gold details on light screens (ornaments, chips).
  static const gold = Brand.gold600;

  // Light surfaces
  static const background = Brand.gold50;
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF3EEDF);
  static const surfaceRaised = Color(0xFFFFFDF7);

  // Light foregrounds
  static const foreground = Brand.navy900;
  static const foregroundMuted = Brand.navy600;
  static const foregroundSubtle = Brand.navy400;

  // Dark surfaces
  static const backgroundDark = Brand.navy950;
  static const surfaceDark = Brand.navy900;
  static const surfaceMutedDark = Brand.navy800;
  static const surfaceRaisedDark = Color(0xFF1C1F3E);

  // Dark foregrounds
  static const foregroundDark = Brand.gold50;
  static const foregroundMutedDark = Brand.navy200;
  static const foregroundSubtleDark = Brand.navy300;

  // Borders
  static const border = Brand.gold200;
  static const borderDark = Brand.navy700;

  static const white = Color(0xFFFFFFFF);
  static const black = Brand.navy950;
  static const red = Brand.wrong;
  static const transparent = Colors.transparent;
}
