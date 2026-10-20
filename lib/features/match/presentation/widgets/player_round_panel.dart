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
import 'strikes_row.dart';

/// What a player does in the current round.
class PlayerRoundPanel extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;

  const PlayerRoundPanel({super.key, required this.match, required this.round});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (round.revealed) {
      return GameBanner(
        icon: Icons.hourglass_top_rounded,
        text: s.match_wait_referee_next,
        color: Colors.white,
      );
    }
    return switch (round.type) {
      RoundType.ayahNumber => _NumberEntry(
        match: match,
        round: round,
        hint: s.match_your_answer,
      ),
      RoundType.auction when round.reciter == null => _BidPanel(
        match: match,
        round: round,
      ),
      RoundType.auction => GameBanner(
        icon: Icons.record_voice_over_rounded,
        color: playerColor(round.reciter!),
        strong: round.reciter == match.you,
        text: round.reciter == match.you
            ? s.match_you_recite(
                round.answers[match.you]?.value?.toArabicDigits ?? '',
              )
            : s.match_other_recites(
                match.participants[round.reciter]?.name ?? '',
                round.answers[round.reciter]?.value?.toArabicDigits ?? '',
              ),
      ),
      RoundType.whatDoYouKnow => _TurnPanel(match: match, round: round),
      RoundType.similar ||
      RoundType.sard => _SpeakPanel(match: match, round: round),
      RoundType.buzzer => _Buzzer(match: match, round: round),
      RoundType.rightLeft => _RightLeftPanel(match: match, round: round),
    };
  }
}

/// A secret number: the ayah count, or a bid.
class _NumberEntry extends StatefulWidget {
  final MatchStateModel match;
  final RoundModel round;
  final String hint;

  const _NumberEntry({
    required this.match,
    required this.round,
    required this.hint,
  });

  @override
  State<_NumberEntry> createState() => _NumberEntryState();
}

class _NumberEntryState extends State<_NumberEntry> {
  final _controller = TextEditingController();

  @override
  void didUpdateWidget(_NumberEntry old) {
    super.didUpdateWidget(old);
    if (old.round.index != widget.round.index) _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final color = roundColor(widget.round.type);
    final mine = widget.round.answers[widget.match.you]!;
    if (mine.submitted) {
      return GameBanner(
        icon: Icons.lock_rounded,
        color: color,
        text: widget.round.type == RoundType.auction
            ? s.match_bid_sent(mine.value?.toArabicDigits ?? '')
            : s.match_wait_reveal,
      );
    }
    final value = int.tryParse(_controller.text);
    return GamePanel(
      tint: color,
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              textAlign: TextAlign.center,
              onChanged: (_) => setState(() {}),
              style: AppTextStyle.display.copyWith(
                fontSize: 30.sp,
                color: GameColors.text,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyle.medium.copyWith(
                  color: GameColors.textSubtle,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 116.w,
            child: GameButton(
              label: s.match_send,
              icon: Icons.send_rounded,
              gradient: GameColors.pair(
                color,
                Color.lerp(color, Colors.black, 0.25)!,
              ),
              onPressed: value == null || value < 1
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      HapticFeedback.mediumImpact();
                      context.read<MatchBloc>().add(
                        MatchAnswerSubmitted(value),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }
}

/// المزاد: open bidding. Both bids show; a bid must beat the highest, and
/// the player behind can raise or tell the other to go ahead and recite.
class _BidPanel extends StatefulWidget {
  final MatchStateModel match;
  final RoundModel round;

  const _BidPanel({required this.match, required this.round});

  @override
  State<_BidPanel> createState() => _BidPanelState();
}

class _BidPanelState extends State<_BidPanel> {
  final _controller = TextEditingController();

  @override
  void didUpdateWidget(_BidPanel old) {
    super.didUpdateWidget(old);
    final high = widget.round.highBidder;
    if (old.round.index != widget.round.index ||
        old.round.answers[high]?.value != widget.round.answers[high]?.value) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final round = widget.round;
    final match = widget.match;
    final me = match.you;
    final color = roundColor(round.type);
    final high = round.highBidder;
    final highBid = high == null ? 0 : (round.answers[high]?.value ?? 0);
    final total = round.question.total ?? 999;
    final value = int.tryParse(_controller.text);
    final canBid = value != null && value > highBid && value <= total;

    final myTurn = round.turn == me;
    final status = high == null
        ? GameBanner(
            icon: Icons.gavel_rounded,
            color: myTurn ? playerColor(me) : color,
            strong: myTurn,
            text: myTurn
                ? s.match_bid_your_open
                : s.match_bid_wait_open(
                    match.participants[round.turn]?.name ?? '',
                  ),
          )
        : high == me
        ? GameBanner(
            icon: Icons.emoji_events_rounded,
            color: playerColor(me),
            strong: true,
            text: s.match_bid_you_high(highBid.toArabicDigits),
          )
        : GameBanner(
            icon: Icons.gavel_rounded,
            color: playerColor(high),
            strong: true,
            text: s.match_bid_high(
              highBid.toArabicDigits,
              match.participants[high]?.name ?? '',
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        status,
        // Bids go in turn: the input only shows on this player's turn.
        if (myTurn && high != me) ...[
          SizedBox(height: 12.h),
          GamePanel(
            tint: color,
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    textAlign: TextAlign.center,
                    onChanged: (_) => setState(() {}),
                    style: AppTextStyle.display.copyWith(
                      fontSize: 30.sp,
                      color: GameColors.text,
                    ),
                    decoration: InputDecoration(
                      hintText: s.match_bid_more_than(highBid.toArabicDigits),
                      hintStyle: AppTextStyle.medium.copyWith(
                        color: GameColors.textSubtle,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                SizedBox(
                  width: 116.w,
                  child: GameButton(
                    label: s.match_bid_raise,
                    icon: Icons.trending_up_rounded,
                    gradient: GameColors.pair(
                      color,
                      Color.lerp(color, Colors.black, 0.25)!,
                    ),
                    onPressed: canBid
                        ? () {
                            FocusScope.of(context).unfocus();
                            HapticFeedback.mediumImpact();
                            context.read<MatchBloc>().add(
                              MatchAnswerSubmitted(value),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
          if (high != null) ...[
            SizedBox(height: 10.h),
            OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                context.read<MatchBloc>().add(const MatchBidPassed());
              },
              icon: const Icon(Icons.record_voice_over_rounded),
              label: Text(s.match_bid_pass),
            ),
          ],
        ],
        SizedBox(height: 8.h),
        // The maximum, and what the typed bid would be worth.
        Text(
          canBid
              ? '${s.match_bid_max(total.toArabicDigits)} · ${s.match_bid_worth(value.toArabicDigits, _points(s, value))}'
              : s.match_bid_max(total.toArabicDigits),
          textAlign: TextAlign.center,
          style: AppTextStyle.small.copyWith(
            color: GameColors.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          s.match_bid_hint,
          textAlign: TextAlign.center,
          style: AppTextStyle.xSmall.copyWith(color: GameColors.textSubtle),
        ),
      ],
    );
  }
}

/// المزاد: a completed recital's worth — 1 point under 20, then a point
/// per full ten (as the server scores it).
String _points(S s, int bid) {
  final n = bid < 20 ? 1 : bid ~/ 10;
  return switch (n) {
    1 => s.match_bid_points1,
    2 => s.match_bid_points2,
    _ => s.match_bid_points(n.toArabicDigits),
  };
}

/// المتشابهات / السرد: no buzzer; players answer aloud, with a few tries
/// each.
class _SpeakPanel extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;

  const _SpeakPanel({required this.match, required this.round});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final out = round.lockedOut.contains(match.you);
    return Column(
      children: [
        GameBanner(
          icon: out ? Icons.block_rounded : Icons.mic_rounded,
          color: out ? GameColors.wrong : roundColor(round.type),
          strong: !out,
          text: round.type == RoundType.sard
              ? (out ? s.match_sard_out : s.match_sard_speak)
              : (out ? s.match_similar_out : s.match_similar_speak),
        ),
        SizedBox(height: 12.h),
        StrikesRow(match: match, round: round, showTurn: false),
      ],
    );
  }
}

/// يمين يسار: two big buttons during this player's run; otherwise whose
/// turn it is. Results show once a run is over.
class _RightLeftPanel extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;

  const _RightLeftPanel({required this.match, required this.round});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rl = round.rightLeft;
    if (rl == null) return const SizedBox.shrink();
    final me = match.you;
    final mine = rl.player == me;
    final color = roundColor(round.type);
    final name = match.participants[rl.player]?.name ?? '';
    final children = <Widget>[];
    if (rl.running && mine) {
      children.add(
        Text(
          s.rl_progress(
            (rl.index + 1).toArabicDigits,
            rl.perRun.toArabicDigits,
          ),
          textAlign: TextAlign.center,
          style: AppTextStyle.medium.copyWith(color: GameColors.textMuted),
        ),
      );
      children.add(SizedBox(height: 10.h));
      Widget button(bool right) => Expanded(
        child: SizedBox(
          height: 96.h,
          child: GameButton(
            label: right ? s.rl_right : s.rl_left,
            icon: right ? Icons.east_rounded : Icons.west_rounded,
            gradient: GameColors.pair(
              color,
              Color.lerp(color, Colors.black, 0.3)!,
            ),
            onPressed: () {
              HapticFeedback.mediumImpact();
              context.read<MatchBloc>().add(MatchSideAnswered(right: right));
            },
          ),
        ),
      );
      // يمين on the right, يسار on the left, whatever the layout direction.
      children.add(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              button(false),
              SizedBox(width: 12.w),
              button(true),
            ],
          ),
        ),
      );
    } else if (rl.running) {
      children.add(
        GameBanner(
          icon: Icons.timer_rounded,
          color: playerColor(rl.player),
          text: s.rl_running_other(
            name,
            (rl.index + 1).toArabicDigits,
            rl.perRun.toArabicDigits,
          ),
        ),
      );
    } else {
      children.add(
        GameBanner(
          icon: mine ? Icons.bolt_rounded : Icons.hourglass_top_rounded,
          color: mine ? playerColor(me) : Colors.white,
          strong: mine,
          text: mine
              ? s.rl_get_ready(
                  rl.perRun.toArabicDigits,
                  round.timeLimitSeconds > 0
                      ? round.timeLimitSeconds.toArabicDigits
                      : '٣',
                )
              : s.rl_waiting_run(name),
        ),
      );
    }
    children.add(SizedBox(height: 12.h));
    children.add(RightLeftResults(match: match, round: round));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

/// يمين يسار: each finished run's ✓ / ✕ per opening and its total.
class RightLeftResults extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;

  const RightLeftResults({super.key, required this.match, required this.round});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rl = round.rightLeft!;
    return Row(
      children: [
        for (final p in [MatchRole.player1, MatchRole.player2]) ...[
          if (p == MatchRole.player2) SizedBox(width: 10.w),
          Expanded(
            child: GamePanel(
              tint: playerColor(p),
              padding: EdgeInsets.all(10.r),
              child: Column(
                children: [
                  Text(
                    rl.results[p]?.finished == true
                        ? s.rl_result(
                            match.participants[p]?.name ?? '',
                            rl.results[p]!.right.toArabicDigits,
                            rl.perRun.toArabicDigits,
                          )
                        : match.participants[p]?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.xSmall.copyWith(
                      color: GameColors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 4.w,
                    children: [
                      for (var i = 0; i < rl.perRun; i++)
                        _Dot(value: rl.results[p]?.correct.elementAtOrNull(i)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  /// Right, wrong, or not shown (null).
  final bool? value;

  const _Dot({required this.value});

  @override
  Widget build(BuildContext context) {
    final color = switch (value) {
      true => GameColors.correct,
      false => GameColors.wrong,
      null => Colors.transparent,
    };
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      alignment: Alignment.center,
      child: value == null
          ? null
          : Icon(
              value! ? Icons.check_rounded : Icons.close_rounded,
              size: 12.r,
              color: Colors.white,
            ),
    );
  }
}

/// ماذا تعرف: whose turn it is and the strikes; answers are spoken.
class _TurnPanel extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;

  const _TurnPanel({required this.match, required this.round});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final mine = round.turn == match.you;
    return Column(
      children: [
        GameBanner(
          icon: mine ? Icons.mic_rounded : Icons.hearing_rounded,
          color: playerColor(round.turn),
          strong: mine,
          text: mine
              ? s.match_your_turn
              : s.match_turn_of(match.participants[round.turn]?.name ?? ''),
        ),
        if (mine && !round.passed.contains(match.you)) ...[
          SizedBox(height: 10.h),
          OutlinedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.read<MatchBloc>().add(const MatchBidPassed());
            },
            icon: const Icon(Icons.redo_rounded),
            label: Text(s.match_pass_turn),
          ),
        ],
        SizedBox(height: 12.h),
        StrikesRow(match: match, round: round),
      ],
    );
  }
}

/// الجرس: a big glowing buzzer that pulses while it can be
/// pressed.
class _Buzzer extends StatefulWidget {
  final MatchStateModel match;
  final RoundModel round;

  const _Buzzer({required this.match, required this.round});

  @override
  State<_Buzzer> createState() => _BuzzerState();
}

class _BuzzerState extends State<_Buzzer> with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);
  bool _down = false;

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final round = widget.round;
    final match = widget.match;
    final me = match.you;
    final active = round.activeBuzzer;
    final locked = round.lockedOut.contains(me);
    final canBuzz = active == null && !locked;
    final mineNow = active == me;
    final color = active != null ? playerColor(active) : roundColor(round.type);

    final label = mineNow && round.lockedOut.isNotEmpty
        ? s.match_your_chance
        : mineNow
        ? s.match_you_buzzed
        : active != null
        ? s.match_other_buzzed(match.participants[active]?.name ?? '')
        : locked
        ? s.match_locked_out
        : s.match_press_buzzer;

    final lit = canBuzz || mineNow;
    final size = 190.r;
    return Column(
      children: [
        GestureDetector(
          onTapDown: canBuzz ? (_) => setState(() => _down = true) : null,
          onTapCancel: () => setState(() => _down = false),
          onTapUp: (_) => setState(() => _down = false),
          onTap: canBuzz
              ? () {
                  HapticFeedback.heavyImpact();
                  context.read<MatchBloc>().add(const MatchBuzzed());
                }
              : null,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final t = canBuzz ? _pulse.value : 0.0;
              return Container(
                width: size + 40.r,
                height: size + 40.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: lit ? 0.10 + 0.14 * t : 0.04),
                ),
                child: AnimatedScale(
                  scale: _down ? 0.92 : 1 + 0.03 * t,
                  duration: const Duration(milliseconds: 100),
                  child: child,
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: lit
                    ? RadialGradient(
                        center: const Alignment(-0.3, -0.4),
                        colors: [
                          Color.lerp(color, Colors.white, 0.35)!,
                          color,
                          Color.lerp(color, Colors.black, 0.35)!,
                        ],
                        stops: const [0, 0.6, 1],
                      )
                    : null,
                color: lit ? null : GameColors.panel,
                border: Border.all(
                  color: Colors.white.withValues(alpha: lit ? 0.7 : 0.15),
                  width: 4,
                ),
                boxShadow: lit
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Icon(
                locked
                    ? Icons.block_rounded
                    : mineNow
                    ? Icons.mic_rounded
                    : Icons.notifications_active_rounded,
                size: 76.r,
                color: lit ? Colors.white : GameColors.textSubtle,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyle.xLarge.copyWith(
            color: lit ? GameColors.text : GameColors.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
