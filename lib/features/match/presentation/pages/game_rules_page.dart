import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/styles/game_theme.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/utils/injections.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/models/match_rules_model.dart';
import '../../domain/usecases/get_match_rules_usecase.dart';
import '../../domain/models/match_state_model.dart';
import '../widgets/game_kit.dart';
import '../widgets/round_labels.dart';

/// How the competition works: the match, then each round's rules for the
/// players and what the referee does, then the referee's tools. The numbers
/// (and which rounds are on) come from the rules set on the dashboard.
class GameRulesPage extends StatefulWidget {
  const GameRulesPage({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(
    context,
  ).push(CupertinoPageRoute(builder: (_) => const GameRulesPage()));

  @override
  State<GameRulesPage> createState() => _GameRulesPageState();
}

class _GameRulesPageState extends State<GameRulesPage> {
  /// The defaults until (or unless) the server's rules arrive.
  MatchRulesModel _rules = const MatchRulesModel();

  @override
  void initState() {
    super.initState();
    sl<GetMatchRulesUseCase>().call(NoParams()).then((r) {
      if (mounted) r.fold((_) {}, (rules) => setState(() => _rules = rules));
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rules = _rules;
    final overview = [
      s.rules_overview(
        rules.enabledRounds.length.toArabicDigits,
        rules.questionsPerRound.toArabicDigits,
      ),
      s.rules_overview_tiebreak,
    ].join('\n');
    return Theme(
      data: gameTheme,
      child: GameStage(
        child: Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(s.rules_title),
          ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 32.h),
            children: [
              GamePanel(
                child: _Section(
                  icon: Icons.emoji_events_rounded,
                  color: GameColors.gold,
                  title: s.rules_overview_title,
                  lines: overview,
                ),
              ),
              for (final type in rules.enabledRounds) ...[
                SizedBox(height: 12.h),
                _RoundRules(type: type, rules: rules),
              ],
              SizedBox(height: 12.h),
              GamePanel(
                tint: GameColors.referee,
                child: _Section(
                  icon: Icons.gavel_rounded,
                  color: GameColors.referee,
                  title: s.rules_referee_general_title,
                  lines: s.rules_referee_general,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundRules extends StatelessWidget {
  final RoundType type;
  final MatchRulesModel rules;

  const _RoundRules({required this.type, required this.rules});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final color = roundColor(type);
    return GamePanel(
      tint: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AppSvg(
                  roundIcon(type),
                  size: 24.r,
                  color: onColor(color),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                roundName(s, type),
                style: AppTextStyle.xLarge.copyWith(
                  color: GameColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _Label(text: s.rules_players, color: color),
          _Bullets(lines: _rules(s, type, rules), color: color),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: GameColors.referee.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.gavel_rounded,
                  size: 18.r,
                  color: GameColors.referee,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label(text: s.rules_referee, color: GameColors.referee),
                      Text(_referee(s, type), style: _body),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _rules(S s, RoundType t, MatchRulesModel r) {
    String time(int seconds) =>
        seconds == 60 ? s.rules_minute : s.rules_secs(seconds.toArabicDigits);
    String points(int n) => switch (n) {
      1 => s.rules_point1,
      2 => s.rules_point2,
      _ => s.rules_points(n.toArabicDigits),
    };
    return switch (t) {
      RoundType.whatDoYouKnow => s.rules_what_do_you_know(
        r.wdykStrikes.toArabicDigits,
        points(r.wdykCleanPoints),
        points(r.wdykPoints),
      ),
      RoundType.ayahNumber => s.rules_ayah_number(
        time(r.ayahSeconds),
        points(r.ayahPoints),
      ),
      RoundType.auction => s.rules_auction(
        time(r.auctionBidSeconds),
        time(r.auctionReciteSeconds),
        points(r.auctionPoints),
      ),
      RoundType.similar => s.rules_similar(
        time(r.similarFastSeconds),
        points(r.similarFastPoints),
        time(r.similarSlowSeconds),
        points(r.similarSlowPoints),
        r.similarStrikes.toArabicDigits,
      ),
      RoundType.sard => s.rules_sard(
        points(r.sardPoints),
        r.sardStrikes.toArabicDigits,
        time(r.sardSeconds),
      ),
      RoundType.ayahByAyah => s.rules_ayah_by_ayah(
        time(r.ayahByAyahSeconds),
        points(r.ayahByAyahPoints),
      ),
      RoundType.rightLeft => s.rules_right_left(
        6.toArabicDigits,
        time(r.rightLeftItemSeconds),
        points(r.rightLeftPoints),
      ),
      RoundType.buzzer => s.rules_buzzer(
        time(r.buzzerSeconds),
        points(r.buzzerPoints),
      ),
    };
  }

  static String _referee(S s, RoundType t) => switch (t) {
    RoundType.whatDoYouKnow => s.referee_what_do_you_know,
    RoundType.ayahNumber => s.referee_ayah_number,
    RoundType.auction => s.referee_auction,
    RoundType.similar => s.referee_similar,
    RoundType.sard => s.referee_sard,
    RoundType.ayahByAyah => s.referee_ayah_by_ayah,
    RoundType.rightLeft => s.referee_right_left,
    RoundType.buzzer => s.referee_buzzer,
  };
}

final _body = AppTextStyle.small.copyWith(
  color: GameColors.textMuted,
  height: 1.7,
);

class _Section extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String lines;

  const _Section({
    required this.icon,
    required this.color,
    required this.title,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22.r),
            SizedBox(width: 8.w),
            Text(
              title,
              style: AppTextStyle.large.copyWith(
                color: GameColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        _Bullets(lines: lines, color: color),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final Color color;

  const _Label({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        text,
        style: AppTextStyle.xSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// One rule per line of [lines], each with a dot in the round's colour.
class _Bullets extends StatelessWidget {
  final String lines;
  final Color color;

  const _Bullets({required this.lines, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final line in lines.split('\n'))
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 9.h),
                  child: Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(child: Text(line, style: _body)),
              ],
            ),
          ),
      ],
    );
  }
}
