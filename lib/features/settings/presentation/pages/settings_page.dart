import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_route_enum.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/quran_fonts.dart';
import '../../../../core/styles/quran_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/app_notifier.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/widgets/icon_badge.dart';
import '../../../../core/widgets/section_label.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final notifier = context.watch<AppNotifier>();
    final colors = context.quranColors;

    return Scaffold(
      appBar: AppBar(title: Text(s.settings)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
        children: [
          SectionLabel(s.appearance),
          _ThemePicker(
            dark: notifier.isDarkTheme,
            onChanged: notifier.updateTheme,
          ),
          SectionLabel(s.quran_font),
          _FontPicker(
            selected: notifier.quranFont,
            onChanged: notifier.updateQuranFont,
          ),
          SectionLabel(s.tajweed),
          _Group(
            children: [
              _SwitchRow(
                icon: Icons.palette_outlined,
                title: s.tajweed_colors,
                subtitle: s.tajweed_colors_subtitle,
                value: notifier.showTajweed,
                onChanged: notifier.updateShowTajweed,
              ),
              _Row(
                icon: Icons.menu_book_outlined,
                title: s.tajweed_guide,
                subtitle: s.tajweed_guide_subtitle,
                // Mirrored in RTL, so it points left — "forward" in Arabic.
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouteEnum.tajweedGuide.name,
                ),
              ),
            ],
          ),
          SectionLabel(s.settings_reading),
          _Group(
            children: [
              _Row(
                icon: Icons.download_for_offline_outlined,
                title: s.library,
                subtitle: s.library_subtitle,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppRouteEnum.library.name),
              ),
            ],
          ),
          SectionLabel(s.settings_competition),
          _Group(
            children: [
              _SwitchRow(
                icon: Icons.volume_up_outlined,
                title: s.game_sounds,
                subtitle: s.game_sounds_subtitle,
                value: notifier.gameSounds,
                onChanged: notifier.updateGameSounds,
              ),
            ],
          ),
          SectionLabel(s.similar_ayahs),
          _Group(
            children: [
              _SwitchRow(
                icon: Icons.compare_arrows_rounded,
                title: s.similar_colors,
                subtitle: s.similar_colors_subtitle,
                value: notifier.showSimilar,
                onChanged: notifier.updateShowSimilar,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(68.w, 0, 16.w, 14.h),
                child: Wrap(
                  spacing: 16.w,
                  runSpacing: 8.h,
                  children: [
                    _Legend(color: colors.similarFull, label: s.similar_full),
                    _Legend(
                      color: colors.similarPartial,
                      label: s.similar_partial,
                    ),
                  ],
                ),
              ),
              _Row(
                icon: Icons.short_text_rounded,
                title: s.similar_min_words,
                subtitle: s.similar_min_words_subtitle,
                trailing: _Stepper(
                  value: notifier.similarMinWords,
                  min: AppNotifier.minSimilarWords,
                  max: AppNotifier.maxSimilarWords,
                  onChanged: notifier.updateSimilarMinWords,
                ),
              ),
            ],
          ),
          SectionLabel(s.about),
          _Group(
            children: [
              _Row(
                icon: Icons.shield_outlined,
                title: s.about,
                subtitle: s.about_subtitle,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant,
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppRouteEnum.about.name),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Light / dark as two preview tiles.
/// The mushaf fonts, each shown with a line of the Quran in it.
class _FontPicker extends StatelessWidget {
  final QuranFont selected;
  final ValueChanged<QuranFont> onChanged;

  const _FontPicker({required this.selected, required this.onChanged});

  static const _sample = 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    String name(QuranFont f) => switch (f) {
      QuranFont.hafs => s.font_hafs,
      QuranFont.amiri => s.font_amiri,
      QuranFont.noto => s.font_noto,
    };
    return _Group(
      children: [
        for (final font in QuranFont.values)
          InkWell(
            onTap: () => onChanged(font),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  Icon(
                    font == selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: font == selected ? scheme.primary : scheme.outline,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          font == QuranFont.hafs
                              ? '${name(font)} · ${s.font_hafs_note}'
                              : name(font),
                          style: AppTextStyle.small.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${font.prepare(_sample)} ${font.ayahMarker(2)}',
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(
                            fontFamily: font.family,
                            fontSize: 22.sp,
                            color: scheme.onSurface,
                            height: 1.9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ThemePicker extends StatelessWidget {
  final bool dark;
  final ValueChanged<bool> onChanged;

  const _ThemePicker({required this.dark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      children: [
        Expanded(
          child: _ThemeTile(
            label: s.light_mode,
            paper: Colors.white,
            ink: Colors.black,
            selected: !dark,
            onTap: () => onChanged(false),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _ThemeTile(
            label: s.dark_mode,
            paper: Colors.black,
            ink: Colors.white,
            selected: dark,
            onTap: () => onChanged(true),
          ),
        ),
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final String label;
  final Color paper;
  final Color ink;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeTile({
    required this.label,
    required this.paper,
    required this.ink,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? scheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 76.h,
              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: paper,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: ink.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'بِسْمِ ٱللَّهِ',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.quranAyah.copyWith(
                      fontSize: 15.sp,
                      color: ink,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  for (final w in [1.0, 0.7])
                    FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: w,
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(top: 4.h),
                        decoration: BoxDecoration(
                          color: ink.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  size: 18.r,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: AppTextStyle.medium.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Rows on one rounded surface, separated by hairlines.
class _Group extends StatelessWidget {
  final List<Widget> children;

  const _Group({required this.children});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _Row({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            IconBadge(icon, size: 40.r),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.large.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyle.small.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[SizedBox(width: 8.w), trailing!],
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _Row(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: () => onChanged(!value),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget button(IconData icon, int? next) => SizedBox(
      width: 34.r,
      height: 34.r,
      child: IconButton.filledTonal(
        padding: EdgeInsets.zero,
        iconSize: 18.r,
        style: IconButton.styleFrom(
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
        ),
        onPressed: next == null ? null : () => onChanged(next),
        icon: Icon(icon),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(Icons.remove_rounded, value > min ? value - 1 : null),
        SizedBox(
          width: 30.w,
          child: Text(
            value.toArabicDigits,
            textAlign: TextAlign.center,
            style: AppTextStyle.large.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        button(Icons.add_rounded, value < max ? value + 1 : null),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14.r,
          height: 14.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTextStyle.small.copyWith(color: scheme.onSurface),
        ),
      ],
    );
  }
}
