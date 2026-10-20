import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';
import '../bloc/match_bloc.dart';
import 'answers_row.dart';
import 'confetti.dart';
import 'game_kit.dart';
import 'player_round_panel.dart';
import 'question_card.dart';
import 'match_setup_view.dart';
import 'referee_round_panel.dart';
import 'remote_media_panel.dart';
import 'role_labels.dart';
import 'scoreboard.dart';

/// Everything inside a match, for whichever role this device holds.
class MatchRoomView extends StatelessWidget {
  final MatchStateModel match;

  const MatchRoomView({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final round = match.round;
    if (match.status == MatchStatus.finished) return _Finished(match: match);
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 32.h),
      children: [
        _MatchHeader(match: match),
        SizedBox(height: 14.h),
        // Remote matches: cameras and voices.
        if (match.mode == MatchMode.remote) ...[
          RemoteMediaPanel(match: match),
          SizedBox(height: 14.h),
        ],
        if (!match.isDraft) ...[
          Scoreboard(match: match),
          SizedBox(height: 16.h),
        ],
        switch (match.status) {
          // The referee prepares a draft before players can enter.
          MatchStatus.lobby when match.isDraft => MatchSetupView(match: match),
          MatchStatus.lobby => _LobbyWaiting(match: match),
          MatchStatus.playing when round != null => AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Column(
              key: ValueKey(round.index),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QuestionCard(match: match, round: round),
                SizedBox(height: 14.h),
                if (round.type.usesNumbers) ...[
                  AnswersRow(match: match, round: round),
                  SizedBox(height: 14.h),
                ],
                if (match.you.isPlayer)
                  PlayerRoundPanel(match: match, round: round)
                else
                  RefereeRoundPanel(match: match, round: round),
              ],
            ),
          ),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}

/// The match code (tap to copy), the referee, the mode and this device's role.
class _MatchHeader extends StatelessWidget {
  final MatchStateModel match;

  const _MatchHeader({required this.match});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final referee = match.participants[MatchRole.referee];
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: match.code));
            HapticFeedback.selectionClick();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(s.match_code_copied)));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: GameColors.panel,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: GameColors.panelBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tag_rounded,
                  color: GameColors.textSubtle,
                  size: 20.r,
                ),
                SizedBox(width: 6.w),
                Text(
                  match.code,
                  style: AppTextStyle.xxxLarge.copyWith(
                    color: GameColors.text,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 5,
                    height: 1.2,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(
                  Icons.copy_rounded,
                  color: GameColors.textSubtle,
                  size: 18.r,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            GameChip(
              label: s.match_you_are(roleLabel(s, match.you)),
              color: playerColor(match.you),
              icon: Icons.person_rounded,
            ),
            GameChip(
              label:
                  '${roleLabel(s, MatchRole.referee)}: ${referee?.name ?? s.match_waiting_seat}',
              color: GameColors.referee,
              icon: Icons.gavel_rounded,
            ),
            GameChip(
              label: match.mode == MatchMode.remote
                  ? s.match_mode_remote
                  : s.match_mode_same_room,
              color: Colors.white,
              icon: match.mode == MatchMode.remote
                  ? Icons.wifi_rounded
                  : Icons.groups_rounded,
            ),
          ],
        ),
      ],
    );
  }
}

/// Before the start: who has taken a seat, and the referee's start button.
class _LobbyWaiting extends StatelessWidget {
  final MatchStateModel match;

  const _LobbyWaiting({required this.match});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final ready = match.bothPlayersJoined;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GamePanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                s.match_seats,
                style: AppTextStyle.small.copyWith(
                  color: GameColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              for (final role in MatchRole.values)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    children: [
                      PlayerAvatar(
                        role: role,
                        name: match.participants[role]?.name,
                        online: match.participants[role]?.connected ?? false,
                        size: 38.r,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              match.participants[role]?.name ??
                                  s.match_waiting_seat,
                              style: AppTextStyle.medium.copyWith(
                                color: match.participants[role] == null
                                    ? GameColors.textSubtle
                                    : GameColors.text,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              roleLabel(s, role),
                              style: AppTextStyle.xSmall.copyWith(
                                color: playerColor(role),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        match.participants[role] != null
                            ? Icons.check_circle_rounded
                            : Icons.more_horiz_rounded,
                        color: match.participants[role] != null
                            ? GameColors.correct
                            : GameColors.textSubtle,
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(
                    Icons.share_rounded,
                    size: 14.r,
                    color: GameColors.textSubtle,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      s.match_share_code,
                      style: AppTextStyle.xSmall.copyWith(
                        color: GameColors.textSubtle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        GameBanner(
          icon: ready ? Icons.verified_rounded : Icons.hourglass_top_rounded,
          color: ready ? GameColors.correct : Colors.white,
          strong: ready,
          text: ready ? s.match_players_ready : s.match_waiting_players,
        ),
        SizedBox(height: 14.h),
        if (match.you == MatchRole.referee)
          GameButton(
            label: s.match_start(match.totalQuestions.toArabicDigits),
            icon: Icons.play_arrow_rounded,
            onPressed: ready
                ? () =>
                      context.read<MatchBloc>().add(const MatchStartRequested())
                : null,
          )
        else
          Text(
            s.match_wait_referee_start,
            textAlign: TextAlign.center,
            style: AppTextStyle.medium.copyWith(color: GameColors.textMuted),
          ),
      ],
    );
  }
}

/// The result: the winner under a trophy (with confetti), or a draw.
class _Finished extends StatelessWidget {
  final MatchStateModel match;

  const _Finished({required this.match});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final winner = match.winner;
    final draw = match.isDraw || winner == null;
    final color = draw ? GameColors.gold : playerColor(winner);
    return Confetti(
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
        children: [
          Center(
            child: Container(
              width: 128.r,
              height: 128.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: GameColors.pair(
                  GameColors.gold,
                  GameColors.refereeEnd,
                ),
                boxShadow: [
                  BoxShadow(
                    color: GameColors.gold.withValues(alpha: 0.55),
                    blurRadius: 50,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                draw ? Icons.handshake_rounded : Icons.emoji_events_rounded,
                size: 68.r,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            draw
                ? s.match_draw
                : s.match_winner(match.participants[winner]?.name ?? ''),
            textAlign: TextAlign.center,
            style: AppTextStyle.xxxLarge.copyWith(
              color: GameColors.text,
              fontWeight: FontWeight.w700,
              shadows: [Shadow(color: color, blurRadius: 24)],
            ),
          ),
          SizedBox(height: 22.h),
          GamePanel(
            child: Column(
              children: [
                Text(
                  s.match_final_score,
                  style: AppTextStyle.small.copyWith(
                    color: GameColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    for (final p in [MatchRole.player1, MatchRole.player2]) ...[
                      if (p == MatchRole.player2)
                        Text(
                          '-',
                          style: AppTextStyle.xxxLarge.copyWith(
                            color: GameColors.textSubtle,
                          ),
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            PlayerAvatar(
                              role: p,
                              name: match.participants[p]?.name,
                              size: 50.r,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              match.participants[p]?.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.medium.copyWith(
                                color: GameColors.text,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${match.scores[p] ?? 0}',
                              style: AppTextStyle.display.copyWith(
                                color: GameColors.text,
                                shadows: [
                                  Shadow(color: playerColor(p), blurRadius: 18),
                                ],
                              ),
                            ),
                            if (p == winner)
                              GameChip(
                                label: s.match_winner_chip,
                                color: GameColors.gold,
                                icon: Icons.emoji_events_rounded,
                                solid: true,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          GameButton(
            label: s.match_new,
            icon: Icons.replay_rounded,
            onPressed: () => context.read<MatchBloc>().add(const MatchLeft()),
          ),
        ],
      ),
    );
  }
}
