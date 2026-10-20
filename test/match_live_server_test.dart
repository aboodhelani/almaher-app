// Plays a whole match through the app's real client code against a running
// server (cd ../almaher-server && npm run start). Skipped if none is running.
import 'dart:io';

import 'package:almaher/core/network/error/failures.dart';
import 'package:dartz/dartz.dart' hide State;

import 'package:almaher/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:almaher/features/match/data/data_sources/remote/match_socket_data_source.dart';
import 'package:almaher/features/match/data/repositories/match_repo_impl.dart';
import 'package:almaher/features/match/domain/models/match_enums.dart';
import 'package:almaher/features/match/domain/models/match_state_model.dart';
import 'package:flutter_test/flutter_test.dart';

Future<bool> _serverUp() async {
  try {
    final s = await Socket.connect(
      'localhost',
      3000,
      timeout: const Duration(seconds: 1),
    );
    s.destroy();
    return true;
  } catch (_) {
    return false;
  }
}

final _run = DateTime.now().millisecondsSinceEpoch;
var _accounts = 0;

/// A match client signed in with a fresh test account (the server only lets
/// accounts play).
Future<MatchRepoImpl> _player([String? name]) async {
  final n = ++_accounts;
  final body = await AuthRemoteDataSource().register(
    email: 'live-$_run-$n@almaher.local',
    password: 'secret1',
    name: name ?? 'لاعب $n',
  );
  final token = body['token'] as String;
  return MatchRepoImpl(MatchSocketDataSource(token: () async => token));
}

/// Fails with the server's error code instead of a bare `false`.
void expectOk(Either<Failure, void> result) {
  expect(result.fold((f) => f.errorMessage, (_) => 'ok'), 'ok');
}

void main() {
  test('referee and two players play رقم الآيات end to end', () async {
    if (!await _serverUp()) {
      markTestSkipped('No match server on localhost:3000');
      return;
    }
    final ref = await _player();
    final p1 = await _player();
    final p2 = await _player();
    MatchStateModel? refLatest, p1Latest;
    ref.states.listen((s) => refLatest = s);
    p1.states.listen((s) => p1Latest = s);

    Future<void> until(bool Function() ok) async {
      for (var i = 0; i < 50 && !ok(); i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      expect(ok(), isTrue);
    }

    final code = (await ref.createMatch(
      MatchMode.sameRoom,
    )).getOrElse(() => '');
    expect(code, hasLength(6));
    expectOk(
      await ref.joinMatch(code: code, role: JoinRole.referee, name: 'الحكم'),
    );
    // Players don't pick a seat: the server gives the first, then the second.
    expectOk(
      await p1.joinMatch(code: code, role: JoinRole.player, name: 'تميم'),
    );
    expectOk(
      await p2.joinMatch(code: code, role: JoinRole.player, name: 'عبادة'),
    );
    await until(() => p1Latest?.you == MatchRole.player1);

    final third = await _player();
    final full = await third.joinMatch(
      code: code,
      role: JoinRole.player,
      name: 'x',
    );
    expect(full.fold((f) => f.errorMessage, (_) => ''), 'match_full');
    await third.leave();

    expectOk(await ref.startMatch());
    await until(() => refLatest?.round != null && p1Latest?.round != null);
    expect(refLatest!.round!.total, 28);

    var p1Expected = 0;
    final seen = <RoundType>[];
    for (var i = 0; i < 28; i++) {
      await until(
        () =>
            refLatest!.round!.index == i &&
            !refLatest!.round!.revealed &&
            p1Latest!.round!.index == i &&
            !p1Latest!.round!.revealed,
      );
      final r = refLatest!.round!;
      seen.add(r.type);
      // Players never get the answer key during a question.
      expect(p1Latest!.round!.question.answer, isNull);
      switch (r.type) {
        case RoundType.ayahNumber:
          final answer = int.parse(r.question.answer!);
          expectOk(await p1.submitAnswer(answer));
          expectOk(await p2.submitAnswer(answer + 7));
          // The referee sees who was fastest; players don't.
          await until(
            () => refLatest!.round!.answers[MatchRole.player2]!.submitted,
          );
          expect(refLatest!.round!.firstAnswered, MatchRole.player1);
          expect(p1Latest!.round!.firstAnswered, isNull);
          expectOk(await ref.reveal());
        case RoundType.auction:
          // Open bids in turn: the opener bids, the other raises, then the
          // opener passes and the raiser recites (and succeeds).
          expect(p1Latest!.round!.question.total, isNotNull);
          final opener = r.turn;
          final second = opener == MatchRole.player1
              ? MatchRole.player2
              : MatchRole.player1;
          final bidders = {MatchRole.player1: p1, MatchRole.player2: p2};
          expectOk(await bidders[opener]!.submitAnswer(1));
          await until(() => refLatest!.round!.highBidder == opener);
          expectOk(await bidders[second]!.submitAnswer(2));
          await until(() => refLatest!.round!.highBidder == second);
          expectOk(await bidders[opener]!.passBid());
          await until(() => refLatest!.round!.reciter == second);
          expectOk(await ref.judge(correct: true));
          // The raiser scores (1 is added below for player1).
          if (second == MatchRole.player2) p1Expected--;
        case RoundType.whatDoYouKnow:
          // Three strikes for whoever starts; the other gets the point.
          final starter = r.turn;
          for (var k = 0; k < 3; k++) {
            if (k > 0) expectOk(await ref.judge(correct: true));
            expectOk(await ref.judge(correct: false));
          }
          // The winner made no mistake: 2 points (1 is added below).
          if (starter == MatchRole.player1) {
            p1Expected--;
          } else {
            p1Expected++;
          }
        case RoundType.similar:
          // No buzzer: the referee judges whoever answered aloud.
          expectOk(await ref.judge(correct: false, player: MatchRole.player2));
          expectOk(await ref.judge(correct: true, player: MatchRole.player1));
          // Answered within 15 seconds is worth 3.
          p1Expected += 2;
        case RoundType.sard:
          // The ayah's last word, answered aloud; 2 tries each.
          expectOk(await ref.judge(correct: false, player: MatchRole.player2));
          expectOk(await ref.judge(correct: false, player: MatchRole.player2));
          expectOk(await ref.judge(correct: true, player: MatchRole.player1));
        case RoundType.rightLeft:
          // Two runs: the first runner is always right, the second always
          // wrong (the referee sees each opening's side).
          final players = {MatchRole.player1: p1, MatchRole.player2: p2};
          MatchRole? first;
          for (var run = 0; run < 2; run++) {
            expectOk(await ref.startRun());
            await until(() => refLatest!.round!.rightLeft!.running);
            final runner = refLatest!.round!.rightLeft!.player;
            first ??= runner;
            for (var k = 0; k < 6; k++) {
              await until(
                () =>
                    refLatest!.round!.rightLeft!.running &&
                    refLatest!.round!.rightLeft!.index == k,
              );
              final right = refLatest!.round!.rightLeft!.side == 'right';
              expectOk(
                await players[runner]!.answerSide(
                  right: run == 0 ? right : !right,
                ),
              );
            }
            await until(
              () => refLatest!.round!.rightLeft!.done.length == run + 1,
            );
          }
          // The first runner wins (1 is added below for player1).
          if (first == MatchRole.player2) p1Expected--;
        case RoundType.buzzer:
          // A wrong answer shows everyone the question and hands it over.
          expectOk(await p2.buzz());
          await until(
            () => refLatest!.round!.activeBuzzer == MatchRole.player2,
          );
          expectOk(await ref.judge(correct: false));
          await until(
            () =>
                p1Latest!.round!.activeBuzzer == MatchRole.player1 &&
                !p1Latest!.round!.question.hidden,
          );
          expectOk(await ref.judge(correct: true));
      }
      p1Expected++;
      await until(
        () => refLatest!.round!.revealed && p1Latest!.round!.revealed,
      );
      expect(
        p1Latest!.round!.question.answer,
        isNotNull,
        reason: 'shown once decided',
      );
      expectOk(await ref.nextQuestion());
    }

    await until(() => refLatest!.status == MatchStatus.finished);
    expect(seen, [for (final t in RoundType.values) ...List.filled(4, t)]);
    expect(refLatest!.scores[MatchRole.player1], p1Expected);

    await ref.adjustScore(MatchRole.player2, 1);
    await Future.wait([ref.leave(), p1.leave(), p2.leave()]);
  });

  test('a chosen match ID, and server matching without one', () async {
    if (!await _serverUp()) {
      markTestSkipped('No match server on localhost:3000');
      return;
    }
    final a = await _player();
    final b = await _player();
    final id = 'test-${DateTime.now().millisecondsSinceEpoch % 100000}';

    // A chosen ID: created once, then joined exactly (case-insensitive).
    expect(
      (await a.createMatch(MatchMode.sameRoom, code: id)).getOrElse(() => ''),
      id,
    );
    expectOk(await a.joinMatch(code: id, role: JoinRole.player, name: 'أ'));
    expectOk(
      await b.joinMatch(
        code: id.toUpperCase(),
        role: JoinRole.player,
        name: 'ب',
      ),
    );
    final again = await b.createMatch(MatchMode.sameRoom, code: id);
    expect(again.fold((f) => f.errorMessage, (_) => ''), 'code_taken');
    await Future.wait([a.leave(), b.leave()]);

    // No ID: two players are matched into the same open match.
    final c = await _player();
    final d = await _player();
    final first = (await c.quickMatch(
      role: JoinRole.player,
      name: 'ج',
      mode: MatchMode.remote,
    )).getOrElse(() => '');
    final second = (await d.quickMatch(
      role: JoinRole.player,
      name: 'د',
      mode: MatchMode.remote,
    )).getOrElse(() => '');
    expect(first, isNotEmpty);
    expect(second, first);
    await Future.wait([c.leave(), d.leave()]);
  });
}
