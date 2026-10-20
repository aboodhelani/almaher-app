import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme.dart';
import 'app_text_style.dart';
import 'game_colors.dart';

/// The competition screens' theme: always dark, on the [GameColors.stage]
/// gradient, so widgets that read the colour scheme come out white-on-stage.
final ThemeData gameTheme = () {
  const scheme = ColorScheme.dark(
    primary: GameColors.whatDoYouKnow,
    onPrimary: Colors.white,
    primaryContainer: Color(0x338B5CF6),
    onPrimaryContainer: Colors.white,
    secondary: GameColors.gold,
    onSecondary: GameColors.stageBottom,
    surface: GameColors.stageTop,
    onSurface: GameColors.text,
    onSurfaceVariant: GameColors.textMuted,
    surfaceContainer: GameColors.panel,
    surfaceContainerHigh: GameColors.panelStrong,
    surfaceContainerHighest: GameColors.panelStrong,
    outline: GameColors.panelBorder,
    outlineVariant: GameColors.panelBorder,
    error: GameColors.wrong,
  );
  final r16 = BorderRadius.circular(16);
  return darkAppTheme.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.transparent,
    canvasColor: GameColors.stageTop,
    appBarTheme: darkAppTheme.appBarTheme.copyWith(
      backgroundColor: Colors.transparent,
      foregroundColor: GameColors.text,
      iconTheme: const IconThemeData(color: GameColors.text, size: 22),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTextStyle.large.copyWith(
        color: GameColors.text,
        fontWeight: FontWeight.w700,
      ),
    ),
    iconTheme: const IconThemeData(color: GameColors.textMuted, size: 22),
    dividerColor: GameColors.panelBorder,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GameColors.panel,
      hintStyle: AppTextStyle.medium.copyWith(color: GameColors.textSubtle),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: r16,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: r16,
        borderSide: const BorderSide(color: GameColors.panelBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: r16,
        borderSide: const BorderSide(color: GameColors.player1End, width: 1.6),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: GameColors.player1End,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: GameColors.stageTop,
        disabledBackgroundColor: GameColors.panel,
        disabledForegroundColor: GameColors.textSubtle,
        minimumSize: const Size(64, 54),
        textStyle: AppTextStyle.large.copyWith(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: r16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: GameColors.text,
        backgroundColor: GameColors.panel,
        side: const BorderSide(color: GameColors.panelBorder),
        minimumSize: const Size(64, 50),
        textStyle: AppTextStyle.medium.copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: r16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: GameColors.text,
        textStyle: AppTextStyle.medium.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: darkAppTheme.snackBarTheme.copyWith(
      backgroundColor: Colors.white,
      contentTextStyle: AppTextStyle.medium.copyWith(
        color: GameColors.stageTop,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: GameColors.text,
    ),
  );
}();
