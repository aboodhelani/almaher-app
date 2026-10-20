import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';
import 'game_kit.dart';

/// Each player's answer: "answered" / "waiting", the value when this role may
/// see it, and a ✓ for who got the point after the reveal.
class AnswersRow extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;

  const AnswersRow({super.key, required this.match, required this.round});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final p in [MatchRole.player1, MatchRole.player2]) ...[
          Expanded(
            child: _Answer(match: match, round: round, player: p),
          ),
          if (p == MatchRole.player1) SizedBox(width: 12.w),
        ],
      ],
    );
  }
}

class _Answer extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;
  final MatchRole player;

  const _Answer({
    required this.match,
    required this.round,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final a = round.answers[player]!;
    final won = round.revealed && round.awarded.contains(player);
    final value = a.value;
    final first = round.firstAnswered == player;
    final taken = a.secondsTaken;
    final color = playerColor(player);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        gradient: won ? playerGradient(player) : null,
        color: won ? null : color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: won
              ? Colors.white.withValues(alpha: 0.6)
              : color.withValues(alpha: 0.4),
          width: won ? 1.5 : 1,
        ),
        boxShadow: won
            ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 20)]
            : null,
      ),
      child: Column(
        children: [
          Text(
            match.participants[player]?.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.small.copyWith(
              color: won ? Colors.white : GameColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: value != null
                ? Text(
                    '$value',
                    key: ValueKey(value),
                    style: AppTextStyle.display.copyWith(
                      fontSize: 34.sp,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    key: ValueKey(a.submitted),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        a.submitted
                            ? Icons.lock_rounded
                            : Icons.more_horiz_rounded,
                        size: 18.r,
                        color: a.submitted ? color : GameColors.textSubtle,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        a.submitted ? s.match_answered : s.match_waiting_answer,
                        style: AppTextStyle.medium.copyWith(
                          color: a.submitted
                              ? GameColors.text
                              : GameColors.textSubtle,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
          if (won)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: GameChip(
                label: s.match_got_point,
                color: Colors.white,
                icon: Icons.add_rounded,
                solid: true,
              ),
            ),
          // Referee only: who was fastest, and each player's time.
          if (first || taken != null)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6.w,
                children: [
                  if (first)
                    GameChip(
                      label: s.match_answered_first,
                      color: GameColors.gold,
                      icon: Icons.bolt_rounded,
                      solid: true,
                    ),
                  if (taken != null)
                    Text(
                      s.match_seconds(_seconds(taken)),
                      style: AppTextStyle.xSmall.copyWith(
                        color: won ? Colors.white : GameColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 2.3 → "٢٫٣"
String _seconds(double v) {
  final text = v.toStringAsFixed(1).replaceAll('.', '٫');
  return text.replaceAllMapped(
    RegExp(r'\d'),
    (m) => '٠١٢٣٤٥٦٧٨٩'[int.parse(m[0]!)],
  );
}
