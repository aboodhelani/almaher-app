import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/match_enums.dart';
import '../models/match_state_model.dart';
import '../repositories/match_repo.dart';

/// Referee: starts the match with the rounds and counts it chose.
class StartMatchUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  StartMatchUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.startMatch();
}

/// Player: presses the buzzer.
class BuzzUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  BuzzUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.buzz();
}

/// Referee: ✓ / ✗ for the answer being given.
class JudgeAnswerUseCase extends UseCase<void, JudgeParams> {
  final MatchRepo repository;

  JudgeAnswerUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(JudgeParams params) => repository.judge(
    correct: params.correct,
    ref: params.ref,
    player: params.player,
  );
}

class JudgeParams {
  final bool correct;

  /// ماذا تعرف: the ayah (`surah:ayah`) the player gave.
  final String? ref;

  /// المتشابهات: who answered.
  final MatchRole? player;

  const JudgeParams({required this.correct, this.ref, this.player});
}

/// Player (المزاد): lets the highest bidder go ahead and recite.
class PassBidUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  PassBidUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.passBid();
}

/// Referee: ends the question with a point for a player, or none (null).
class AwardPointUseCase extends UseCase<void, MatchRole?> {
  final MatchRepo repository;

  AwardPointUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MatchRole? params) =>
      repository.award(params);
}

/// Player: submits their secret answer.
class SubmitAnswerUseCase extends UseCase<void, int> {
  final MatchRepo repository;

  SubmitAnswerUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) =>
      repository.submitAnswer(params);
}

/// Referee: reveals and scores the current question.
class RevealAnswersUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  RevealAnswersUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.reveal();
}

/// Referee: moves to the next question (or finishes the match).
class NextQuestionUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  NextQuestionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.nextQuestion();
}

/// Referee: corrects a player's score by [AdjustScoreParams.delta].
class AdjustScoreUseCase extends UseCase<void, AdjustScoreParams> {
  final MatchRepo repository;

  AdjustScoreUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AdjustScoreParams params) =>
      repository.adjustScore(params.player, params.delta);
}

class AdjustScoreParams {
  final MatchRole player;
  final int delta;

  const AdjustScoreParams(this.player, this.delta);
}

/// Referee: swaps the current question for an alternative one.
class ReplaceQuestionUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  ReplaceQuestionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.replaceQuestion();
}

/// Referee: ends the match now, with the current scores.
class EndMatchUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  EndMatchUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.endMatch();
}

/// Player: gives up the current question; the other player gets its points.
class ForfeitQuestionUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  ForfeitQuestionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.forfeitQuestion();
}

/// Player: quits the match; the other player wins it.
class ForfeitMatchUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  ForfeitMatchUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.forfeitMatch();
}

/// Remote matches: joins this seat to the match's audio/video room.
class GetMediaTokenUseCase extends UseCase<MediaTokenModel, NoParams> {
  final MatchRepo repository;

  GetMediaTokenUseCase(this.repository);

  @override
  Future<Either<Failure, MediaTokenModel>> call(NoParams params) =>
      repository.mediaToken();
}

class SetupQuestionsParams {
  final RoundType type;

  /// New generated questions instead of the bank's.
  final bool generated;

  const SetupQuestionsParams(this.type, {this.generated = false});
}

/// Referee, preparing: questions to pick from for a round.
class GetSetupQuestionsUseCase
    extends UseCase<List<QuestionModel>, SetupQuestionsParams> {
  final MatchRepo repository;

  GetSetupQuestionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<QuestionModel>>> call(
    SetupQuestionsParams params,
  ) => repository.setupQuestions(params.type, generated: params.generated);
}

/// Referee, preparing: the rounds the match plays and their question counts.
class SetRoundCountsUseCase extends UseCase<void, Map<RoundType, int>> {
  final MatchRepo repository;

  SetRoundCountsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Map<RoundType, int> params) =>
      repository.setRoundCounts(params);
}

class RoundQuestionsParams {
  final RoundType type;
  final List<Map<String, dynamic>> questions;

  const RoundQuestionsParams(this.type, this.questions);
}

/// Referee, preparing: the questions chosen for one round.
class SetRoundQuestionsUseCase extends UseCase<void, RoundQuestionsParams> {
  final MatchRepo repository;

  SetRoundQuestionsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RoundQuestionsParams params) =>
      repository.setRoundQuestions(params.type, params.questions);
}

/// Referee: opens the prepared match to players.
class PublishMatchUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  PublishMatchUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      repository.publishMatch();
}

/// Player (يمين يسار): right (true) or left page.
class AnswerSideUseCase extends UseCase<void, bool> {
  final MatchRepo repository;

  AnswerSideUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(bool params) =>
      repository.answerSide(right: params);
}

/// Referee (يمين يسار): starts the waiting player's run.
class StartRunUseCase extends UseCase<void, NoParams> {
  final MatchRepo repository;

  StartRunUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.startRun();
}
