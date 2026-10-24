import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/brand_colors.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/star_pattern.dart';

/// Reading: an ink card (black in light mode, white in dark mode) with the
/// star lattice and an accent call to action.
class QuranHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback onTap;

  const QuranHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ink = scheme.onSurface;
    final paper = scheme.surface;
    return _PressableCard(
      onTap: onTap,
      decoration: BoxDecoration(
        color: ink,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: StarPattern(
              color: paper.withValues(alpha: 0.07),
              spacing: 40,
            ),
          ),
          PositionedDirectional(
            end: -18.w,
            bottom: -22.h,
            child: Icon(
              Icons.menu_book_rounded,
              size: 150.r,
              color: paper.withValues(alpha: 0.08),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(22.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: paper.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    color: paper,
                    size: 26.r,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  title,
                  style: AppTextStyle.xxxLarge.copyWith(
                    color: paper,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTextStyle.medium.copyWith(
                    color: paper.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 18.h),
                _Pill(
                  label: action,
                  background: Brand.gold500,
                  foreground: Brand.navy950,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The competition: a navy card edged in gold, with the round icons.
class GameHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String caption;
  final String action;
  final VoidCallback onTap;

  const GameHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.caption,
    required this.action,
    required this.onTap,
  });

  static const _rounds = [
    ('round_what_do_you_know.svg', GameColors.whatDoYouKnow),
    ('round_ayah_number.svg', GameColors.ayahNumber),
    ('round_auction.svg', GameColors.auction),
    ('round_similar.svg', GameColors.similar),
    ('round_sard.svg', GameColors.sard),
    ('round_ayah_by_ayah.svg', GameColors.ayahByAyah),
    ('round_right_left.svg', GameColors.rightLeft),
    ('round_buzzer.svg', GameColors.buzzer),
  ];

  @override
  Widget build(BuildContext context) {
    return _PressableCard(
      onTap: onTap,
      decoration: BoxDecoration(
        gradient: GameColors.promo,
        border: Border.all(color: Brand.gold500.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Brand.navy900.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: StarPattern(
              color: Colors.white.withValues(alpha: 0.10),
              spacing: 40,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(22.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Two rows, so every round fits on any width.
                for (final row in [_rounds.take(4), _rounds.skip(4)])
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        for (final (icon, color) in row)
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 8.w),
                            child: Container(
                              width: 38.r,
                              height: 38.r,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: color.withValues(alpha: 0.55),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: AppSvg(icon, size: 22.r, color: color),
                            ),
                          ),
                      ],
                    ),
                  ),
                SizedBox(height: 10.h),
                Text(
                  title,
                  style: AppTextStyle.xxxLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTextStyle.medium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    _Pill(
                      label: action,
                      background: Brand.gold500,
                      foreground: Brand.navy950,
                      icon: Icons.play_arrow_rounded,
                    ),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Text(
                        caption,
                        style: AppTextStyle.small.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A small square shortcut under the two main cards.
class HomeShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HomeShortcut({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _PressableCard(
      onTap: onTap,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: scheme.primary, size: 22.r),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.medium.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurfaceVariant,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyle.small.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 4.w),
          // Mirrored in RTL, so it points left — "forward" in Arabic.
          Icon(
            icon ?? Icons.arrow_forward_rounded,
            color: foreground,
            size: 16.r,
          ),
        ],
      ),
    );
  }
}

/// Shrinks slightly while pressed.
class _PressableCard extends StatefulWidget {
  final Widget child;
  final BoxDecoration decoration;
  final VoidCallback onTap;

  const _PressableCard({
    required this.child,
    required this.decoration,
    required this.onTap,
  });

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: widget.decoration,
          clipBehavior: Clip.antiAlias,
          child: widget.child,
        ),
      ),
    );
  }
}
