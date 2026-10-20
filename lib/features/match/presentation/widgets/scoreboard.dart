import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';
import 'game_kit.dart';
import 'role_labels.dart';

/// Both players face to face: avatar, name, connection and score, with the
/// one answering now lit up.
class Scoreboard extends StatelessWidget {
  final MatchStateModel match;

  const Scoreboard({super.key, required this.match});

  /// Who is answering in the current question, if anyone in particular.
  MatchRole? get _answering {
    final r = match.round;
    if (r == null || r.revealed || match.status != MatchStatus.playing) {
      return null;
    }
    return switch (r.type) {
      RoundType.whatDoYouKnow => r.turn,
      RoundType.auction => r.reciter ?? r.highBidder,
      RoundType.buzzer => r.activeBuzzer,
      RoundType.rightLeft =>
        r.rightLeft?.running == true ? r.rightLeft!.player : null,
      // Answered aloud by either player: nobody is singled out.
      RoundType.similar || RoundType.sard || RoundType.ayahNumber => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final answering = _answering;
    // During play the board shrinks to one row per player, leaving room for
    // the question and the controls.
    final compact = match.status == MatchStatus.playing;
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: _PlayerScore(
                match: match,
                role: MatchRole.player1,
                active: answering == MatchRole.player1,
                compact: compact,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _PlayerScore(
                match: match,
                role: MatchRole.player2,
                active: answering == MatchRole.player2,
                compact: compact,
              ),
            ),
          ],
        ),
        if (!compact)
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GameColors.stageTop,
              border: Border.all(color: GameColors.panelBorder, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              s.match_vs,
              style: AppTextStyle.xSmall.copyWith(
                color: GameColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _PlayerScore extends StatelessWidget {
  final MatchStateModel match;
  final MatchRole role;
  final bool active;
  final bool compact;

  const _PlayerScore({
    required this.match,
    required this.role,
    required this.active,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final p = match.participants[role];
    final isYou = match.you == role;
    final color = playerColor(role);
    final score = match.scores[role] ?? 0;
    final scoreText = AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, anim) => ScaleTransition(
        scale: Tween(
          begin: 1.6,
          end: 1.0,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.elasticOut)),
        child: FadeTransition(opacity: anim, child: child),
      ),
      // Western digits: the Arabic zero is a dot, unreadable as a score.
      child: Text(
        '$score',
        key: ValueKey(score),
        style: AppTextStyle.display.copyWith(
          fontSize: compact ? 30.sp : null,
          color: GameColors.text,
          shadows: [Shadow(color: color, blurRadius: 18)],
        ),
      ),
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: compact
          ? EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h)
          : EdgeInsets.fromLTRB(10.w, 14.h, 10.w, 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: active ? 0.45 : 0.22),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(compact ? 20.r : 24.r),
        border: Border.all(
          color: color.withValues(alpha: active ? 1 : 0.45),
          width: active ? 2 : 1,
        ),
        boxShadow: active
            ? [BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 22)]
            : null,
      ),
      child: compact
          ? Row(
              children: [
                PlayerAvatar(
                  role: role,
                  name: p?.name,
                  online: p?.connected ?? false,
                  size: 36.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p?.name ?? s.match_waiting_seat,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.small.copyWith(
                          color: GameColors.text,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        active
                            ? s.match_answering_now
                            : isYou
                            ? s.match_you_short
                            : roleLabel(s, role),
                        style: AppTextStyle.xSmall.copyWith(
                          color: active ? Colors.white : GameColors.textSubtle,
                          fontWeight: active ? FontWeight.w700 : null,
                        ),
                      ),
                    ],
                  ),
                ),
                scoreText,
              ],
            )
          : Column(
              children: [
                PlayerAvatar(
                  role: role,
                  name: p?.name,
                  online: p?.connected ?? false,
                  size: 48.r,
                ),
                SizedBox(height: 8.h),
                Text(
                  p?.name ?? s.match_waiting_seat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.medium.copyWith(
                    color: p == null ? GameColors.textSubtle : GameColors.text,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                Text(
                  roleLabel(s, role),
                  style: AppTextStyle.xSmall.copyWith(
                    color: GameColors.textSubtle,
                  ),
                ),
                SizedBox(height: 4.h),
                scoreText,
                SizedBox(height: 6.h),
                SizedBox(
                  height: 20.h,
                  child: active
                      ? GameChip(
                          label: s.match_answering_now,
                          color: color,
                          icon: Icons.mic_rounded,
                          solid: true,
                        )
                      : isYou
                      ? GameChip(label: s.match_you_short, color: Colors.white)
                      : null,
                ),
              ],
            ),
    );
  }
}
