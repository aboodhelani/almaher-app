import 'package:flutter/material.dart';

/// The brand palette, from the logo: deep navy and gold, each in shades.
/// Red and green are kept for wrong and correct only.
abstract class Brand {
  // Navy (the logo's ground)
  static const navy950 = Color(0xFF0E1024);
  static const navy900 = Color(0xFF181A35);
  static const navy800 = Color(0xFF22264A);
  static const navy700 = Color(0xFF2E3361);
  static const navy600 = Color(0xFF3C4380);
  static const navy500 = Color(0xFF545C9E);
  static const navy400 = Color(0xFF7F87C2);
  static const navy300 = Color(0xFFA5ABD3);
  static const navy200 = Color(0xFFCBD0EA);
  static const navy100 = Color(0xFFE6E8F4);
  static const navy50 = Color(0xFFF4F5FB);

  // Gold (the logo's calligraphy)
  static const gold800 = Color(0xFF7C6424);
  static const gold700 = Color(0xFF9C7F2E);
  static const gold600 = Color(0xFFB8963F);
  static const gold500 = Color(0xFFC9A54A);
  static const gold400 = Color(0xFFD8BB6E);
  static const gold300 = Color(0xFFE0C77F);
  static const gold200 = Color(0xFFEBDDB0);
  static const gold100 = Color(0xFFF6EFD9);
  static const gold50 = Color(0xFFFBF8EE);

  // Verdicts only
  static const correct = Color(0xFF2E9E5B);
  static const wrong = Color(0xFFD64545);
}
