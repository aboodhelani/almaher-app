import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/widgets/star_pattern.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';

/// Colour of each seat.
Color playerColor(MatchRole role) => switch (role) {
  MatchRole.player1 => GameColors.player1,
  MatchRole.player2 => GameColors.player2,
  MatchRole.referee => GameColors.referee,
};

LinearGradient playerGradient(MatchRole role) => switch (role) {
  MatchRole.player1 => GameColors.pair(
    GameColors.player1,
    GameColors.player1End,
  ),
  MatchRole.player2 => GameColors.pair(
    GameColors.player2,
    GameColors.player2End,
  ),
  MatchRole.referee => GameColors.pair(
    GameColors.referee,
    GameColors.refereeEnd,
  ),
};

/// Colour of each round.
Color roundColor(RoundType type) => switch (type) {
  RoundType.whatDoYouKnow => GameColors.whatDoYouKnow,
  RoundType.ayahNumber => GameColors.ayahNumber,
  RoundType.auction => GameColors.auction,
  RoundType.similar => GameColors.similar,
  RoundType.sard => GameColors.sard,
  RoundType.ayahByAyah => GameColors.ayahByAyah,
  RoundType.rightLeft => GameColors.rightLeft,
  RoundType.buzzer => GameColors.buzzer,
};

/// The dark stage behind every competition screen: a gradient, a soft glow
/// tinted by [glow] (e.g. the current round), and the star lattice.
class GameStage extends StatelessWidget {
  final Widget child;
  final Color? glow;

  const GameStage({super.key, required this.child, this.glow});

  @override
  Widget build(BuildContext context) {
    final tint = glow ?? GameColors.stageGlow;
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: GameColors.stage),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -1.1),
                  radius: 1.1,
                  colors: [tint.withValues(alpha: 0.45), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: StarPattern(
              color: Colors.white.withValues(alpha: 0.035),
              spacing: 52,
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

/// A frosted panel on the stage.
class GamePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? tint;
  final double? radius;

  const GamePanel({
    super.key,
    required this.child,
    this.padding,
    this.tint,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: tint?.withValues(alpha: 0.12) ?? GameColors.panel,
        borderRadius: BorderRadius.circular(radius ?? 24.r),
        border: Border.all(
          color: tint?.withValues(alpha: 0.45) ?? GameColors.panelBorder,
        ),
      ),
      child: child,
    );
  }
}

/// Readable text on [background]: navy on light colours, white on dark.
Color onColor(Color background) => background.computeLuminance() > 0.45
    ? GameColors.stageBottom
    : Colors.white;

/// A big call to action in a gradient, with a glow; greyed out when
/// [onPressed] is null.
class GameButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final bool busy;

  /// Text and icon colour; by default dark on light buttons, else white.
  final Color? foreground;

  /// Puts the icon after the label (on the left in Arabic), e.g. a
  /// "next" arrow.
  final bool trailingIcon;

  const GameButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient = GameColors.cta,
    this.busy = false,
    this.foreground,
    this.trailingIcon = false,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.busy;
    final glow = widget.gradient.colors.last;
    final foreground =
        widget.foreground ?? onColor(widget.gradient.colors.first);
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _down = true) : null,
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 110),
        child: AnimatedOpacity(
          opacity: enabled || widget.busy ? 1 : 0.4,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 58.h,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: glow.withValues(alpha: 0.45),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: widget.busy
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: foreground,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null && !widget.trailingIcon) ...[
                        Icon(widget.icon, color: foreground, size: 22.r),
                        SizedBox(width: 8.w),
                      ],
                      Flexible(
                        child: Text(
                          widget.label,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.large.copyWith(
                            color: foreground,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (widget.icon != null && widget.trailingIcon) ...[
                        SizedBox(width: 8.w),
                        Icon(widget.icon, color: foreground, size: 22.r),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// A seat's initial in its gradient circle, with an online dot.
class PlayerAvatar extends StatelessWidget {
  final MatchRole role;
  final String? name;
  final bool online;
  final double? size;

  const PlayerAvatar({
    super.key,
    required this.role,
    required this.name,
    this.online = true,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final side = size ?? 52.r;
    final initial = (name?.trim().isNotEmpty ?? false)
        ? name!.trim().characters.first
        : '؟';
    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: name == null ? null : playerGradient(role),
              color: name == null ? GameColors.panel : null,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: AppTextStyle.xLarge.copyWith(
                fontSize: side * 0.4,
                color: name == null ? Colors.white : onColor(playerColor(role)),
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
          if (name != null)
            PositionedDirectional(
              end: -1,
              bottom: -1,
              child: Container(
                width: side * 0.28,
                height: side * 0.28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: online ? GameColors.correct : GameColors.textSubtle,
                  border: Border.all(color: GameColors.stageTop, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A small rounded label, e.g. "أنت" or "الأسرع".
class GameChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool solid;

  const GameChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.solid = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = solid ? GameColors.stageBottom : color;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: solid ? color : color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(100),
        border: solid ? null : Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13.r, color: fg),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: AppTextStyle.xSmall.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// A ring that empties as [fraction] goes from 1 to 0.
class ProgressRing extends StatelessWidget {
  final double fraction;
  final Color color;
  final double size;
  final double stroke;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.fraction,
    required this.color,
    required this.size,
    this.stroke = 4,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(fraction.clamp(0, 1), color, stroke),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double fraction;
  final Color color;
  final double stroke;

  _RingPainter(this.fraction, this.color, this.stroke);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inner = rect.deflate(stroke / 2);
    canvas.drawArc(
      inner,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    canvas.drawArc(
      inner,
      -math.pi / 2,
      math.pi * 2 * fraction,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color;
}

/// A one-line status on the stage, glowing in [color] when [strong].
class GameBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final bool strong;

  const GameBanner({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: strong ? 0.28 : 0.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withValues(alpha: strong ? 0.9 : 0.3),
          width: strong ? 1.6 : 1,
        ),
        boxShadow: strong
            ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 22)]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: strong ? Colors.white : color, size: 22.r),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: (strong ? AppTextStyle.xLarge : AppTextStyle.large)
                  .copyWith(
                    color: GameColors.text,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
