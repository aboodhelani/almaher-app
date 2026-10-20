import 'package:almaher/features/match/domain/models/match_state_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads the rounds the referee chose and their counts', () {
    final m = MatchStateModel.fromJson({
      'code': '1',
      'perRound': 4,
      'rounds': ['what_do_you_know'],
      'roundCounts': {'what_do_you_know': 20},
      'availableRounds': ['what_do_you_know', 'buzzer'],
      'maxPerRound': 30,
    });
    expect(m.rounds, [RoundType.whatDoYouKnow]);
    expect(m.countFor(RoundType.whatDoYouKnow), 20);
    expect(m.countFor(RoundType.buzzer), 0);
    expect(m.totalQuestions, 20);
    expect(m.availableRounds, [RoundType.whatDoYouKnow, RoundType.buzzer]);
  });

  test('older servers: every round at perRound', () {
    final m = MatchStateModel.fromJson({'code': '1', 'perRound': 4});
    expect(m.totalQuestions, 4 * RoundType.values.length);
  });

  test('a round knows its size and the match segments', () {
    final r = RoundModel.fromJson({
      'type': 'buzzer',
      'roundSize': 3,
      'segments': [
        {'type': 'buzzer', 'count': 3},
        {'type': 'sard', 'count': 1},
      ],
    });
    expect(r.roundSize, 3);
    expect(r.segments.map((s) => (s.type, s.count)), [
      (RoundType.buzzer, 3),
      (RoundType.sard, 1),
    ]);
  });
}
