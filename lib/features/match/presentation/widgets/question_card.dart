import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/models/match_state_model.dart';
import 'countdown_text.dart';
import 'game_kit.dart';
import 'round_labels.dart';

/// The current question, in its round's colour: which round, where it sits
/// in the match, the timer, the prompt, and the answer once this role may
/// see it.
class QuestionCard extends StatelessWidget {
  final MatchStateModel match;
  final RoundModel round;

  const QuestionCard({super.key, required this.match, required this.round});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final q = round.question;
    final isAyah = round.type == RoundType.ayahNumber;
    // Quran words (an ayah, or an ayah's opening) use the mushaf font.
    final quranText =
        isAyah ||
        round.type == RoundType.sard ||
        round.type == RoundType.ayahByAyah ||
        (round.type == RoundType.rightLeft && round.rightLeft?.running == true);
    final answer = q.answer;
    final color = roundColor(round.type);

    return GamePanel(
      tint: color,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 14,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: AppSvg(
                  roundIcon(round.type),
                  size: 26.r,
                  color: onColor(color),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roundName(s, round.type),
                      style: AppTextStyle.xLarge.copyWith(
                        color: GameColors.text,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      s.match_round_of(
                        (round.roundIndex + 1).toArabicDigits,
                        round.roundTotal.toArabicDigits,
                        (round.indexInRound + 1).toArabicDigits,
                        round.roundSize.toArabicDigits,
                      ),
                      style: AppTextStyle.xSmall.copyWith(
                        color: GameColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (round.worth case final worth? when !round.revealed) ...[
                GameChip(
                  label: s.match_points_chip(worth.toArabicDigits),
                  color: GameColors.gold,
                  icon: Icons.star_rounded,
                  solid: true,
                ),
                SizedBox(width: 8.w),
              ],
              if (round.tiebreak) ...[
                GameChip(
                  label: s.match_tiebreak_chip,
                  color: GameColors.gold,
                  icon: Icons.local_fire_department_rounded,
                  solid: true,
                ),
                SizedBox(width: 8.w),
              ],
              if (round.replaced) ...[
                GameChip(
                  label: s.match_replaced_chip,
                  color: GameColors.gold,
                  icon: Icons.swap_horiz_rounded,
                ),
                SizedBox(width: 8.w),
              ],
              if (!round.revealed && round.timeLimitSeconds > 0)
                CountdownText(
                  seconds: round.secondsLeft,
                  total: round.timeLimitSeconds,
                  since: match.receivedAt,
                  color: color,
                )
              else if (round.revealed)
                GameChip(
                  label: s.match_question_done,
                  color: Colors.white,
                  icon: Icons.check_rounded,
                ),
            ],
          ),
          SizedBox(height: 14.h),
          _MatchTrack(round: round),
          SizedBox(height: 16.h),
          if (q.hidden)
            _HiddenPrompt(color: color)
          else if (quranText)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: color.withValues(alpha: 0.35)),
              ),
              child: Text(
                q.prompt,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTextStyle.quranAyah.copyWith(
                  fontSize: 22.sp,
                  height: 2,
                  color: GameColors.text,
                ),
              ),
            )
          else
            Text(
              q.prompt,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyle.xxLarge.copyWith(
                color: GameColors.text,
                fontWeight: FontWeight.w700,
                height: 1.6,
              ),
            ),
          if (q.total != null) ...[
            SizedBox(height: 10.h),
            Center(
              child: GameChip(
                label: s.match_auction_total(q.total!.toArabicDigits),
                color: color,
                icon: Icons.format_list_numbered_rounded,
              ),
            ),
          ],
          if (answer != null) ...[
            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: GameColors.correct.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: GameColors.correct.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.key_rounded,
                    color: GameColors.correct,
                    size: 20.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      isAyah
                          ? s.match_page_answer(
                              '${q.meta['surahName'] ?? ''}',
                              (int.tryParse('${q.meta['page']}') ?? 0)
                                  .toArabicDigits,
                              _ayahCount(int.tryParse(answer) ?? 0),
                            )
                          : round.type == RoundType.ayahByAyah
                          ? s.match_aba_source(
                              '${q.meta['surahName'] ?? ''}',
                              (int.tryParse('${q.meta['ayah']}') ?? 0)
                                  .toArabicDigits,
                            )
                          : round.type == RoundType.sard
                          ? '${s.match_answer_label}: $answer · ${q.meta['surahName'] ?? ''} ${(int.tryParse('${q.meta['ayah']}') ?? 0).toArabicDigits}'
                          : '${s.match_answer_label}: $answer',
                      style: AppTextStyle.medium.copyWith(
                        color: GameColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14.r,
                color: GameColors.textSubtle,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  roundInstruction(s, round.type, strikes: round.maxStrikes),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.xSmall.copyWith(
                    color: GameColors.textSubtle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// الجرس: the question is read out by the referee; players see it after.
class _HiddenPrompt extends StatelessWidget {
  final Color color;

  const _HiddenPrompt({required this.color});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Icon(Icons.hearing_rounded, size: 40.r, color: color),
          SizedBox(height: 8.h),
          Text(
            s.match_listen_question,
            textAlign: TextAlign.center,
            style: AppTextStyle.xLarge.copyWith(
              color: GameColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            s.match_listen_hint,
            textAlign: TextAlign.center,
            style: AppTextStyle.small.copyWith(color: GameColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Every question of the match as a short bar, grouped by round in the
/// round's colour: done ones filled, the current one bright.
class _MatchTrack extends StatelessWidget {
  final RoundModel round;

  const _MatchTrack({required this.round});

  @override
  Widget build(BuildContext context) {
    final segments = round.segments.isNotEmpty
        ? round.segments
        : [RoundSegment(round.type, round.total)];
    // Long rounds (e.g. 20 of one) share the width by their size.
    final starts = <int>[];
    var start = 0;
    for (final seg in segments) {
      starts.add(start);
      start += seg.count;
    }
    return Row(
      children: [
        for (var r = 0; r < segments.length; r++) ...[
          if (r > 0) SizedBox(width: 6.w),
          Expanded(
            flex: segments[r].count,
            child: Row(
              children: [
                for (var i = 0; i < segments[r].count; i++) ...[
                  if (i > 0) SizedBox(width: 2.w),
                  Expanded(
                    child: _Tick(
                      index: starts[r] + i,
                      current: round.index,
                      color: roundColor(segments[r].type),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Tick extends StatelessWidget {
  final int index;
  final int current;
  final Color color;

  const _Tick({
    required this.index,
    required this.current,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final done = index < current;
    final now = index == current;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: now ? 7.h : 5.h,
      decoration: BoxDecoration(
        color: now
            ? Colors.white
            : done
            ? color
            : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        boxShadow: now
            ? [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.6),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
    );
  }
}

/// "٧ آيات" / "١٥ آية": Arabic counted noun is plural only for 3–10.
String _ayahCount(int n) {
  final mod100 = n % 100;
  final noun = mod100 >= 3 && mod100 <= 10 ? 'آيات' : 'آية';
  return '${n.toArabicDigits} $noun';
}
