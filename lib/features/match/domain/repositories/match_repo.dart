import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../models/match_enums.dart';
import '../models/match_state_model.dart';

abstract class MatchRepo {
  /// Snapshots of the joined match, as the server sends them.
  Stream<MatchStateModel> get states;

  /// Creates a match (under [code] if given) and returns its code.
  Future<Either<Failure, String>> createMatch(
    MatchMode mode, {
    String? code,
    bool asReferee = false,
  });

  Future<Either<Failure, void>> joinMatch({
    required String code,
    required JoinRole role,
    required String name,
  });

  /// No ID: the server seats this user in an open match (or a new one) and
  /// returns its code.
  Future<Either<Failure, String>> quickMatch({
    required JoinRole role,
    required String name,
    required MatchMode mode,
  });

  /// Referee: starts the match with the rounds and counts it chose.
  Future<Either<Failure, void>> startMatch();

  /// Player: presses the buzzer (المتشابهات، الجرس).
  Future<Either<Failure, void>> buzz();

  /// Referee: ✓ / ✗ for the answer being given; [ref] ticks an ayah off in
  /// ماذا تعرف.
  /// المتشابهات: [player] says who answered.
  Future<Either<Failure, void>> judge({
    required bool correct,
    String? ref,
    MatchRole? player,
  });

  /// Player (المزاد): lets the highest bidder go ahead and recite.
  Future<Either<Failure, void>> passBid();

  /// Player (يمين يسار): the page of the opening on screen is on [right].
  Future<Either<Failure, void>> answerSide({required bool right});

  /// Referee (يمين يسار): starts the waiting player's run.
  Future<Either<Failure, void>> startRun();

  /// Referee, preparing: bank questions of a round, or new generated ones.
  Future<Either<Failure, List<QuestionModel>>> setupQuestions(
    RoundType type, {
    bool generated = false,
  });

  /// Referee, preparing: which rounds the match plays and how many
  /// questions each (rounds left out, or 0, are skipped).
  Future<Either<Failure, void>> setRoundCounts(Map<RoundType, int> counts);

  /// Referee, preparing: the questions chosen for one round.
  Future<Either<Failure, void>> setRoundQuestions(
    RoundType type,
    List<Map<String, dynamic>> questions,
  );

  /// Referee: opens the prepared match to players.
  Future<Either<Failure, void>> publishMatch();

  /// Referee: ends the question with a point for [player], or none.
  Future<Either<Failure, void>> award(MatchRole? player);

  Future<Either<Failure, void>> submitAnswer(int value);

  Future<Either<Failure, void>> reveal();

  /// Remote matches: a token for this seat in the audio/video room.
  Future<Either<Failure, MediaTokenModel>> mediaToken();

  /// Referee: swaps the current question for an alternative of the same round.
  Future<Either<Failure, void>> replaceQuestion();

  Future<Either<Failure, void>> nextQuestion();

  Future<Either<Failure, void>> adjustScore(MatchRole player, int delta);

  Future<void> leave();
}
