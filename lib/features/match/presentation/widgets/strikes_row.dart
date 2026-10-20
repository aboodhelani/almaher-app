import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';
import 'game_kit.dart';

/// ماذا تعرف / المتشابهات: each player's strikes (red ✕ used, empty ring
/// left), with the player whose turn it is lit up when [showTurn].
class StrikesRow extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;
  final bool showTurn;

  const StrikesRow({
    super.key,
    required this.match,
    required this.round,
    this.showTurn = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final p in [MatchRole.player1, MatchRole.player2]) ...[
          if (p == MatchRole.player2) SizedBox(width: 12.w),
          Expanded(
            child: _Strikes(
              match: match,
              round: round,
              player: p,
              showTurn: showTurn,
            ),
          ),
        ],
      ],
    );
  }
}

class _Strikes extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;
  final MatchRole player;
  final bool showTurn;

  const _Strikes({
    required this.match,
    required this.round,
    required this.player,
    required this.showTurn,
  });

  @override
  Widget build(BuildContext context) {
    final color = playerColor(player);
    final turn = showTurn && round.turn == player && !round.revealed;
    final used = round.strikes[player] ?? 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: turn ? 0.25 : 0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: color.withValues(alpha: turn ? 1 : 0.35),
          width: turn ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            [
              match.participants[player]?.name ?? '',
              if (round.passed.contains(player))
                '· ${S.of(context).match_passed}',
            ].join(' '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.small.copyWith(
              color: turn ? GameColors.text : GameColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < round.maxStrikes; i++)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < used ? GameColors.wrong : Colors.transparent,
                      border: Border.all(
                        color: i < used
                            ? GameColors.wrong
                            : Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: i < used
                          ? [
                              BoxShadow(
                                color: GameColors.wrong.withValues(alpha: 0.5),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: i < used
                        ? Icon(
                            Icons.close_rounded,
                            size: 15.r,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
