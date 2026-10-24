import 'match_state_model.dart';

/// The competition rules managed from the dashboard (see the server's
/// `src/rules/rules.types.ts`).
class MatchRulesModel {
  final int questionsPerRound;
  final List<RoundType> enabledRounds;

  final int wdykPoints;
  final int wdykCleanPoints;
  final int wdykStrikes;
  final int ayahPoints;
  final int ayahSeconds;
  final int auctionPoints;
  final int auctionBidSeconds;
  final int auctionReciteSeconds;
  final int similarStrikes;
  final int similarFastSeconds;
  final int similarFastPoints;
  final int similarSlowSeconds;
  final int similarSlowPoints;
  final int sardPoints;
  final int sardSeconds;
  final int sardStrikes;
  final int ayahByAyahPoints;
  final int ayahByAyahSeconds;
  final int rightLeftPoints;
  final int rightLeftItemSeconds;
  final int buzzerPoints;
  final int buzzerSeconds;

  const MatchRulesModel({
    this.questionsPerRound = 4,
    this.enabledRounds = RoundType.values,
    this.wdykPoints = 1,
    this.wdykCleanPoints = 2,
    this.wdykStrikes = 3,
    this.ayahPoints = 1,
    this.ayahSeconds = 60,
    this.auctionPoints = 1,
    this.auctionBidSeconds = 60,
    this.auctionReciteSeconds = 45,
    this.similarStrikes = 3,
    this.similarFastSeconds = 15,
    this.similarFastPoints = 3,
    this.similarSlowSeconds = 45,
    this.similarSlowPoints = 2,
    this.sardPoints = 1,
    this.sardSeconds = 30,
    this.sardStrikes = 2,
    this.ayahByAyahPoints = 1,
    this.ayahByAyahSeconds = 45,
    this.rightLeftPoints = 1,
    this.rightLeftItemSeconds = 3,
    this.buzzerPoints = 1,
    this.buzzerSeconds = 60,
  });

  factory MatchRulesModel.fromJson(Map<String, dynamic> json) {
    const d = MatchRulesModel();
    final rounds = (json['rounds'] as Map?) ?? const {};
    int n(String round, String key, int fallback) =>
        ((rounds[round] as Map?)?[key] as num?)?.toInt() ?? fallback;
    return MatchRulesModel(
      questionsPerRound:
          (json['questionsPerRound'] as num?)?.toInt() ?? d.questionsPerRound,
      enabledRounds: json['enabledRounds'] is List
          ? [
              for (final t in RoundType.values)
                if ((json['enabledRounds'] as List).contains(t.wire)) t,
            ]
          : RoundType.values,
      wdykPoints: n('what_do_you_know', 'points', d.wdykPoints),
      wdykCleanPoints: n('what_do_you_know', 'cleanPoints', d.wdykCleanPoints),
      wdykStrikes: n('what_do_you_know', 'strikes', d.wdykStrikes),
      ayahPoints: n('ayah_number', 'points', d.ayahPoints),
      ayahSeconds: n('ayah_number', 'seconds', d.ayahSeconds),
      auctionPoints: n('auction', 'points', d.auctionPoints),
      auctionBidSeconds: n('auction', 'bidSeconds', d.auctionBidSeconds),
      auctionReciteSeconds: n(
        'auction',
        'reciteSeconds',
        d.auctionReciteSeconds,
      ),
      similarStrikes: n('similar', 'strikes', d.similarStrikes),
      similarFastSeconds: n('similar', 'fastSeconds', d.similarFastSeconds),
      similarFastPoints: n('similar', 'fastPoints', d.similarFastPoints),
      similarSlowSeconds: n('similar', 'slowSeconds', d.similarSlowSeconds),
      similarSlowPoints: n('similar', 'slowPoints', d.similarSlowPoints),
      sardPoints: n('sard', 'points', d.sardPoints),
      sardSeconds: n('sard', 'seconds', d.sardSeconds),
      sardStrikes: n('sard', 'strikes', d.sardStrikes),
      ayahByAyahPoints: n('ayah_by_ayah', 'points', d.ayahByAyahPoints),
      ayahByAyahSeconds: n('ayah_by_ayah', 'seconds', d.ayahByAyahSeconds),
      rightLeftPoints: n('right_left', 'points', d.rightLeftPoints),
      rightLeftItemSeconds: n(
        'right_left',
        'itemSeconds',
        d.rightLeftItemSeconds,
      ),
      buzzerPoints: n('buzzer', 'points', d.buzzerPoints),
      buzzerSeconds: n('buzzer', 'seconds', d.buzzerSeconds),
    );
  }
}
