import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'brand_colors.dart';
import 'app_text_style.dart';
import 'quran_colors.dart';

/// Light theme – white background, black text, indigo accent.
final ThemeData appTheme = _buildTheme(Brightness.light);

/// Dark theme – black background, white text, soft indigo accent.
final ThemeData darkAppTheme = _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final background = dark ? AppColors.backgroundDark : AppColors.background;
  final surface = dark ? AppColors.surfaceDark : AppColors.surface;
  final muted = dark ? AppColors.surfaceMutedDark : AppColors.surfaceMuted;
  final ink = dark ? AppColors.foregroundDark : AppColors.foreground;
  final inkMuted = dark
      ? AppColors.foregroundMutedDark
      : AppColors.foregroundMuted;
  final inkSubtle = dark
      ? AppColors.foregroundSubtleDark
      : AppColors.foregroundSubtle;
  final border = dark ? AppColors.borderDark : AppColors.border;
  final accent = dark ? AppColors.accentDark : AppColors.accent;
  final accentSoft = dark ? AppColors.accentSoftDark : AppColors.accentSoft;
  final onAccent = dark ? AppColors.black : AppColors.white;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: accent,
    onPrimary: onAccent,
    primaryContainer: accentSoft,
    onPrimaryContainer: accent,
    // Gold for ornaments and highlights.
    secondary: dark ? Brand.gold400 : Brand.gold600,
    onSecondary: Brand.navy950,
    error: AppColors.red,
    onError: AppColors.white,
    surface: background,
    onSurface: ink,
    onSurfaceVariant: inkSubtle,
    surfaceContainerLowest: background,
    surfaceContainerLow: dark
        ? AppColors.surfaceRaisedDark
        : AppColors.surfaceRaised,
    surfaceContainer: muted,
    surfaceContainerHigh: muted,
    surfaceContainerHighest: muted,
    outline: border,
    outlineVariant: border,
  );

  TextStyle ui(TextStyle s) => s.copyWith(color: ink);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: AppTextStyle.uiFont,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    cardColor: surface,
    dividerColor: border,
    dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: ink,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyle.large.copyWith(
        color: ink,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: ink, size: 22),
      actionsIconTheme: IconThemeData(color: ink, size: 22),
      systemOverlayStyle: dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: AppColors.transparent,
      showDragHandle: true,
      dragHandleColor: border,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: AppColors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ink,
      contentTextStyle: AppTextStyle.medium.copyWith(color: background),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    iconTheme: IconThemeData(color: inkMuted, size: 22),
    listTileTheme: ListTileThemeData(
      iconColor: inkMuted,
      titleTextStyle: AppTextStyle.large.copyWith(
        color: ink,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: AppTextStyle.small.copyWith(color: inkSubtle),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    ),
    textTheme: TextTheme(
      displaySmall: ui(AppTextStyle.display),
      headlineSmall: ui(
        AppTextStyle.xxxLarge,
      ).copyWith(fontWeight: FontWeight.w700),
      titleLarge: ui(
        AppTextStyle.xxLarge,
      ).copyWith(fontWeight: FontWeight.w700),
      titleMedium: ui(AppTextStyle.large).copyWith(fontWeight: FontWeight.w600),
      titleSmall: ui(AppTextStyle.medium).copyWith(fontWeight: FontWeight.w600),
      bodyLarge: ui(AppTextStyle.large),
      bodyMedium: ui(AppTextStyle.medium),
      bodySmall: AppTextStyle.small.copyWith(color: inkSubtle),
      labelLarge: ui(AppTextStyle.medium).copyWith(fontWeight: FontWeight.w600),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ink,
        foregroundColor: background,
        disabledBackgroundColor: ink.withValues(alpha: 0.12),
        disabledForegroundColor: inkSubtle,
        minimumSize: const Size(64, 54),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        textStyle: AppTextStyle.large.copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        textStyle: AppTextStyle.medium.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        side: BorderSide(color: border, width: 1.5),
        minimumSize: const Size(64, 54),
        textStyle: AppTextStyle.large.copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: ink),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: muted,
      hintStyle: AppTextStyle.medium.copyWith(color: inkSubtle),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent, width: 1.6),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: accent,
      selectionColor: accent.withValues(alpha: 0.25),
      selectionHandleColor: accent,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? accent
              : AppColors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? onAccent : ink,
        ),
        side: WidgetStatePropertyAll(BorderSide(color: border)),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? onAccent : inkSubtle,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? accent : muted,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? accent : border,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: muted,
      selectedColor: accentSoft,
      side: BorderSide.none,
      labelStyle: AppTextStyle.small.copyWith(
        color: ink,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    extensions: [dark ? QuranColors.dark : QuranColors.light],
  );
}
