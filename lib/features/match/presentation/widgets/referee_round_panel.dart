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
import 'game_kit.dart';
import 'player_round_panel.dart';
import 'strikes_row.dart';

/// The referee runs the question: round-specific judging, next question, and
/// (folded away) a manual point and score corrections.
class RefereeRoundPanel extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;

  const RefereeRoundPanel({
    super.key,
    required this.match,
    required this.round,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = context.read<MatchBloc>();
    final color = roundColor(round.type);
    String name(MatchRole? p) => match.participants[p]?.name ?? '';
    final roundGradient = GameColors.pair(
      color,
      Color.lerp(color, Colors.black, 0.3)!,
    );

    final judging = <Widget>[];
    void gap() => judging.add(SizedBox(height: 12.h));
    if (!round.revealed) {
      switch (round.type) {
        case RoundType.ayahNumber:
          judging.add(
            GameButton(
              label: s.match_reveal,
              icon: Icons.visibility_rounded,
              gradient: roundGradient,
              onPressed: () => bloc.add(const MatchRevealRequested()),
            ),
          );
        case RoundType.auction when round.reciter == null:
          final high = round.highBidder;
          judging.add(
            high == null
                ? GameBanner(
                    icon: Icons.gavel_rounded,
                    color: color,
                    text: s.match_bid_none,
                  )
                : GameBanner(
                    icon: Icons.gavel_rounded,
                    color: playerColor(high),
                    strong: true,
                    text: s.match_bid_high(
                      round.answers[high]?.value?.toArabicDigits ?? '',
                      name(high),
                    ),
                  ),
          );
          gap();
          judging.add(
            GameButton(
              label: s.match_close_bids,
              icon: Icons.gavel_rounded,
              gradient: roundGradient,
              onPressed: () => bloc.add(const MatchRevealRequested()),
            ),
          );
        case RoundType.auction:
          judging.add(
            GameBanner(
              icon: Icons.record_voice_over_rounded,
              color: playerColor(round.reciter!),
              strong: true,
              text: s.match_other_recites(
                name(round.reciter),
                round.answers[round.reciter]?.value?.toArabicDigits ?? '',
              ),
            ),
          );
          gap();
          judging.add(
            _Verdicts(correct: s.match_recite_ok, wrong: s.match_recite_fail),
          );
        case RoundType.whatDoYouKnow:
          judging.add(
            GameBanner(
              icon: Icons.mic_rounded,
              color: playerColor(round.turn),
              strong: true,
              text: s.match_turn_of(name(round.turn)),
            ),
          );
          gap();
          judging.add(StrikesRow(match: match, round: round));
          gap();
          judging.add(
            _Verdicts(correct: s.match_correct, wrong: s.match_strike),
          );
          if (!round.passed.contains(round.turn)) {
            gap();
            judging.add(
              OutlinedButton.icon(
                onPressed: () => bloc.add(const MatchBidPassed()),
                icon: const Icon(Icons.redo_rounded),
                label: Text(s.match_pass_for(name(round.turn))),
              ),
            );
          }
          judging.add(_AnswerList(round: round));
        case RoundType.ayahByAyah:
          final next = round.chain?.next;
          judging.add(
            GameBanner(
              icon: Icons.mic_rounded,
              color: playerColor(round.turn),
              strong: true,
              text: s.match_turn_of(name(round.turn)),
            ),
          );
          if (next != null) {
            gap();
            judging.add(
              GameBanner(
                icon: Icons.key_rounded,
                color: GameColors.correct,
                text: s.match_aba_next(
                  next.opening,
                  next.surahName,
                  next.ayah.toArabicDigits,
                ),
              ),
            );
          }
          gap();
          judging.add(
            _Verdicts(correct: s.match_correct, wrong: s.match_wrong),
          );
          gap();
          judging.add(AyahChainList(round: round));
        case RoundType.similar || RoundType.sard:
          judging.add(
            GameBanner(
              icon: Icons.mic_rounded,
              color: color,
              text: s.match_similar_referee,
            ),
          );
          gap();
          judging.add(StrikesRow(match: match, round: round, showTurn: false));
          for (final p in [MatchRole.player1, MatchRole.player2]) {
            if (round.lockedOut.contains(p)) continue;
            gap();
            judging.add(_PlayerVerdicts(player: p, name: name(p)));
          }
        case RoundType.rightLeft:
          final rl = round.rightLeft;
          if (rl == null) break;
          if (!rl.running) {
            judging.add(
              GameButton(
                label: s.rl_start_run(name(rl.player)),
                icon: Icons.play_arrow_rounded,
                gradient: roundGradient,
                onPressed: () => bloc.add(const MatchRunStarted()),
              ),
            );
          } else {
            judging.add(
              GameBanner(
                icon: Icons.key_rounded,
                color: playerColor(rl.player),
                strong: true,
                text: s.rl_key(
                  rl.side == 'right' ? s.rl_right : s.rl_left,
                  (rl.page ?? 0).toArabicDigits,
                  rl.surahName ?? '',
                  (rl.ayah ?? 0).toArabicDigits,
                ),
              ),
            );
          }
          gap();
          judging.add(RightLeftResults(match: match, round: round));
        case RoundType.buzzer:
          final active = round.activeBuzzer;
          judging.add(
            active == null
                ? GameBanner(
                    icon: Icons.notifications_none_rounded,
                    color: color,
                    text: s.match_waiting_buzz,
                  )
                : GameBanner(
                    icon: Icons.notifications_active_rounded,
                    color: playerColor(active),
                    strong: true,
                    text: round.lockedOut.isNotEmpty
                        ? s.match_handed_over(
                            name(round.lockedOut.first),
                            name(active),
                          )
                        : s.match_other_buzzed(name(active)),
                  ),
          );
          if (active != null) {
            gap();
            judging.add(
              _Verdicts(correct: s.match_correct, wrong: s.match_wrong),
            );
          }
      }
    }

    // Mirrored in RTL: an arrow pointing left, after the label (on the left).
    final next = GameButton(
      label: round.isLastQuestion ? s.match_finish : s.match_next,
      icon: round.isLastQuestion
          ? Icons.emoji_events_rounded
          : Icons.arrow_forward_rounded,
      trailingIcon: true,
      onPressed: () => bloc.add(const MatchNextRequested()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...judging,
        // The referee can always swap the question or move on, in any round
        // and phase (an undecided question ends with no point).
        if (judging.isNotEmpty) SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: () => _confirmReplace(context),
          icon: const Icon(Icons.swap_horiz_rounded),
          label: Text(s.match_replace),
        ),
        SizedBox(height: 12.h),
        next,
        SizedBox(height: 16.h),
        _RefereeTools(match: match, round: round),
      ],
    );
  }
}

/// Asks before swapping the question for an alternative.
Future<void> _confirmReplace(BuildContext context) async {
  final s = S.of(context);
  final bloc = context.read<MatchBloc>();
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: GameColors.stageTop,
      title: Text(s.match_replace_title),
      content: Text(s.match_replace_body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(s.match_cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(s.match_replace_do),
        ),
      ],
    ),
  );
  if (ok == true) bloc.add(const MatchReplaceRequested());
}

/// Asks before ending the match with the current scores.
Future<void> _confirmEnd(BuildContext context) async {
  final s = S.of(context);
  final bloc = context.read<MatchBloc>();
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: GameColors.stageTop,
      title: Text(s.match_end_title),
      content: Text(s.match_end_body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(s.match_cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: GameColors.wrong),
          onPressed: () => Navigator.pop(context, true),
          child: Text(s.match_end_do),
        ),
      ],
    ),
  );
  if (ok == true) bloc.add(const MatchEndRequested());
}

/// ✓ / ✗ for the answer being given.
class _Verdicts extends StatelessWidget {
  final String correct;
  final String wrong;

  const _Verdicts({required this.correct, required this.wrong});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MatchBloc>();
    return Row(
      children: [
        Expanded(
          child: GameButton(
            label: correct,
            icon: Icons.check_rounded,
            gradient: GameColors.pair(
              GameColors.correct,
              const Color(0xFF237A46),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              bloc.add(const MatchJudged(correct: true));
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GameButton(
            label: wrong,
            icon: Icons.close_rounded,
            gradient: GameColors.pair(
              GameColors.wrong,
              const Color(0xFFA83434),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              bloc.add(const MatchJudged(correct: false));
            },
          ),
        ),
      ],
    );
  }
}

/// المتشابهات: ✓ / ✗ for one player's spoken answer.
class _PlayerVerdicts extends StatelessWidget {
  final MatchRole player;
  final String name;

  const _PlayerVerdicts({required this.player, required this.name});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = context.read<MatchBloc>();
    final color = playerColor(player);
    return GamePanel(
      tint: color,
      padding: EdgeInsets.all(10.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.medium.copyWith(
                color: GameColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 104.w,
            child: GameButton(
              label: s.match_correct,
              icon: Icons.check_rounded,
              gradient: GameColors.pair(
                GameColors.correct,
                const Color(0xFF237A46),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                bloc.add(MatchJudged(correct: true, player: player));
              },
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 104.w,
            child: GameButton(
              label: s.match_wrong,
              icon: Icons.close_rounded,
              gradient: GameColors.pair(
                GameColors.wrong,
                const Color(0xFFA83434),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                bloc.add(MatchJudged(correct: false, player: player));
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A manual point (or none) and score corrections, folded away by default.
class _RefereeTools extends StatefulWidget {
  final MatchStateModel match;
  final RoundModel round;

  const _RefereeTools({required this.match, required this.round});

  @override
  State<_RefereeTools> createState() => _RefereeToolsState();
}

class _RefereeToolsState extends State<_RefereeTools> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final bloc = context.read<MatchBloc>();
    final match = widget.match;
    String name(MatchRole p) => match.participants[p]?.name ?? '';
    return GamePanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: GameColors.referee,
                    size: 22.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.referee_tools,
                          style: AppTextStyle.medium.copyWith(
                            color: GameColors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          s.referee_tools_hint,
                          style: AppTextStyle.xSmall.copyWith(
                            color: GameColors.textSubtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more_rounded),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: _open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!widget.round.revealed) ...[
                    _ToolLabel(s.match_manual_point),
                    Row(
                      children: [
                        for (final p in [
                          MatchRole.player1,
                          MatchRole.player2,
                        ]) ...[
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: playerColor(p).withValues(alpha: 0.6),
                                ),
                                backgroundColor: playerColor(
                                  p,
                                ).withValues(alpha: 0.12),
                              ),
                              onPressed: () => bloc.add(MatchPointAwarded(p)),
                              child: Text(
                                name(p),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                bloc.add(const MatchPointAwarded(null)),
                            child: Text(s.match_no_point),
                          ),
                        ),
                      ],
                    ),
                  ],
                  _ToolLabel(s.match_adjust_scores),
                  for (final p in [MatchRole.player1, MatchRole.player2])
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          PlayerAvatar(role: p, name: name(p), size: 34.r),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              name(p),
                              style: AppTextStyle.medium.copyWith(
                                color: GameColors.text,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _RoundButton(
                            icon: Icons.remove_rounded,
                            onTap: () => bloc.add(MatchScoreAdjusted(p, -1)),
                          ),
                          SizedBox(
                            width: 40.w,
                            child: Text(
                              (match.scores[p] ?? 0).toArabicDigits,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.xLarge.copyWith(
                                color: GameColors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          _RoundButton(
                            icon: Icons.add_rounded,
                            onTap: () => bloc.add(MatchScoreAdjusted(p, 1)),
                          ),
                        ],
                      ),
                    ),
                  _ToolLabel(s.match_end_now),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: GameColors.wrong,
                      side: BorderSide(
                        color: GameColors.wrong.withValues(alpha: 0.6),
                      ),
                    ),
                    onPressed: () => _confirmEnd(context),
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: Text(s.match_end_do),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolLabel extends StatelessWidget {
  final String text;

  const _ToolLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 6.h, bottom: 8.h),
    child: Text(
      text,
      style: AppTextStyle.xSmall.copyWith(
        color: GameColors.textMuted,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GameColors.panelStrong,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34.r,
          height: 34.r,
          child: Icon(icon, size: 18.r, color: GameColors.text),
        ),
      ),
    );
  }
}

/// ماذا تعرف: the answer key; tapping an ayah marks it given (✓ for the
/// player whose turn it is).
class _AnswerList extends StatelessWidget {
  final RoundModel round;

  const _AnswerList({required this.round});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final refs = round.question.refs;
    if (refs.isEmpty) return const SizedBox.shrink();
    final progress = refs.isEmpty ? 0.0 : round.saidCount / refs.length;
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: GamePanel(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.match_answer_key(
                      round.saidCount.toArabicDigits,
                      refs.length.toArabicDigits,
                    ),
                    style: AppTextStyle.small.copyWith(
                      color: GameColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      color: GameColors.correct,
                      backgroundColor: GameColors.panel,
                    ),
                  ),
                ],
              ),
            ),
            for (final r in refs)
              InkWell(
                onTap: r.said
                    ? null
                    : () => context.read<MatchBloc>().add(
                        MatchJudged(correct: true, ref: r.key),
                      ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 26.r,
                        height: 26.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: r.said
                              ? GameColors.correct
                              : Colors.transparent,
                          border: Border.all(
                            color: r.said
                                ? GameColors.correct
                                : GameColors.textSubtle,
                            width: 1.5,
                          ),
                        ),
                        child: r.said
                            ? Icon(
                                Icons.check_rounded,
                                size: 16.r,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                              style: AppTextStyle.quranAyah.copyWith(
                                fontSize: 16.sp,
                                height: 1.8,
                                color: r.said
                                    ? GameColors.textSubtle
                                    : GameColors.text,
                              ),
                            ),
                            Text(
                              '${r.surahName} ${r.ayah.toArabicDigits}',
                              style: AppTextStyle.xSmall.copyWith(
                                color: GameColors.textSubtle,
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
        ),
      ),
    );
  }
}
