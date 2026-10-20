import 'package:flutter/material.dart';

import 'brand_colors.dart';

/// The competition's palette: a navy stage lit in gold, with the players,
/// referee and rounds in shades of the brand's navy and gold. Green and red
/// are only for correct and wrong.
abstract class GameColors {
  // Stage
  static const stageTop = Brand.navy800;
  static const stageBottom = Brand.navy950;
  static const stageGlow = Brand.gold700;
  static const panel = Color(0x14FFFFFF);
  static const panelStrong = Color(0x24FFFFFF);
  static const panelBorder = Color(0x26FFFFFF);
  static const text = Color(0xFFFFFFFF);
  static const textMuted = Color(0xB3FFFFFF);
  static const textSubtle = Color(0x80FFFFFF);

  // People
  static const player1 = Brand.gold500;
  static const player1End = Brand.gold300;
  static const player2 = Brand.navy400;
  static const player2End = Brand.navy200;
  static const referee = Brand.gold200;
  static const refereeEnd = Brand.gold400;

  // Verdicts
  static const correct = Brand.correct;
  static const wrong = Brand.wrong;
  static const gold = Brand.gold400;

  // Rounds, in the show's order
  static const whatDoYouKnow = Brand.gold500;
  static const ayahNumber = Brand.navy300;
  static const auction = Brand.gold300;
  static const similar = Brand.navy400;
  static const sard = Brand.gold600;
  static const rightLeft = Brand.navy200;
  static const buzzer = Brand.gold200;

  /// Background of every competition screen.
  static const stage = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [stageTop, stageBottom],
  );

  /// The main call to action: gold.
  static const cta = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Brand.gold300, Brand.gold600],
  );

  /// The home screen's competition card.
  static const promo = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Brand.navy700, Brand.navy900, Brand.navy950],
  );

  static LinearGradient pair(Color a, Color b) => LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [a, b],
  );
}
