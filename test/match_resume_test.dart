import 'dart:async';

import 'package:almaher/core/network/error/failures.dart';
import 'package:almaher/features/match/data/data_sources/local/match_session_prefs.dart';
import 'package:almaher/features/match/domain/models/match_enums.dart';
import 'package:almaher/features/match/domain/models/match_state_model.dart';
import 'package:almaher/features/match/domain/repositories/match_repo.dart';
import 'package:almaher/features/match/domain/usecases/match_usecases.dart';
import 'package:almaher/features/match/presentation/bloc/match_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A server stand-in: joining succeeds and pushes a snapshot.
class _FakeRepo implements MatchRepo {
  @override
  Future<Either<Failure, void>> replaceQuestion() async => const Right(null);
  @override
  Future<Either<Failure, void>> endMatch() async => const Right(null);
  @override
  Future<Either<Failure, void>> forfeitQuestion() async => const Right(null);
  @override
  Future<Either<Failure, void>> forfeitMatch() async => const Right(null);

  @override
  Future<Either<Failure, MediaTokenModel>> mediaToken() async =>
      const Left(ServerFailure('not_remote'));

  final _states = StreamController<MatchStateModel>.broadcast();
  final joins = <(String, JoinRole, String)>[];
  String status = 'lobby';
  bool matchExists = true;

  void push(String code, {String status = 'lobby'}) => _states.add(
    MatchStateModel.fromJson({
      'code': code,
      'status': status,
      'you': 'player2',
      'participants': {},
      'scores': {'player1': 0, 'player2': 0},
    }),
  );

  @override
  Stream<MatchStateModel> get states => _states.stream;

  @override
  Future<Either<Failure, void>> joinMatch({
    required String code,
    required JoinRole role,
    required String name,
  }) async {
    if (!matchExists) return const Left(ServerFailure('match_not_found'));
    joins.add((code, role, name));
    scheduleMicrotask(() => push(code, status: status));
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> quickMatch({
    required JoinRole role,
    required String name,
    required MatchMode mode,
  }) async {
    joins.add(('auto', role, name));
    scheduleMicrotask(() => push('555111'));
    return const Right('555111');
  }

  @override
  Future<Either<Failure, String>> createMatch(
    MatchMode mode, {
    String? code,
    bool asReferee = false,
  }) async => Right(code ?? '123456');
  @override
  Future<Either<Failure, void>> startMatch() async => const Right(null);
  @override
  Future<Either<Failure, void>> buzz() async => const Right(null);
  @override
  Future<Either<Failure, void>> judge({
    required bool correct,
    String? ref,
    MatchRole? player,
  }) async => const Right(null);
  @override
  Future<Either<Failure, void>> passBid() async => const Right(null);
  @override
  Future<Either<Failure, void>> answerSide({required bool right}) async =>
      const Right(null);
  @override
  Future<Either<Failure, void>> startRun() async => const Right(null);
  @override
  Future<Either<Failure, List<QuestionModel>>> setupQuestions(
    RoundType type, {
    bool generated = false,
  }) async => const Right([]);
  @override
  Future<Either<Failure, void>> setRoundCounts(
    Map<RoundType, int> counts,
  ) async => const Right(null);
  @override
  Future<Either<Failure, void>> setRoundQuestions(
    RoundType type,
    List<Map<String, dynamic>> questions,
  ) async => const Right(null);
  @override
  Future<Either<Failure, void>> publishMatch() async => const Right(null);
  @override
  Future<Either<Failure, void>> award(MatchRole? player) async =>
      const Right(null);
  @override
  Future<Either<Failure, void>> submitAnswer(int value) async =>
      const Right(null);
  @override
  Future<Either<Failure, void>> reveal() async => const Right(null);
  @override
  Future<Either<Failure, void>> nextQuestion() async => const Right(null);
  @override
  Future<Either<Failure, void>> adjustScore(
    MatchRole player,
    int delta,
  ) async => const Right(null);
  @override
  Future<void> leave() async {}
}

MatchBloc _bloc(_FakeRepo repo, MatchSessionPrefs prefs) => MatchBloc(
  repo: repo,
  createMatchUseCase: CreateMatchUseCase(repo),
  joinMatchUseCase: JoinMatchUseCase(repo),
  quickMatchUseCase: QuickMatchUseCase(repo),
  startMatchUseCase: StartMatchUseCase(repo),
  buzzUseCase: BuzzUseCase(repo),
  passBidUseCase: PassBidUseCase(repo),
  answerSideUseCase: AnswerSideUseCase(repo),
  startRunUseCase: StartRunUseCase(repo),
  getSetupQuestionsUseCase: GetSetupQuestionsUseCase(repo),
  setRoundCountsUseCase: SetRoundCountsUseCase(repo),
  setRoundQuestionsUseCase: SetRoundQuestionsUseCase(repo),
  publishMatchUseCase: PublishMatchUseCase(repo),
  judgeAnswerUseCase: JudgeAnswerUseCase(repo),
  awardPointUseCase: AwardPointUseCase(repo),
  submitAnswerUseCase: SubmitAnswerUseCase(repo),
  revealAnswersUseCase: RevealAnswersUseCase(repo),
  replaceQuestionUseCase: ReplaceQuestionUseCase(repo),
  endMatchUseCase: EndMatchUseCase(repo),
  forfeitQuestionUseCase: ForfeitQuestionUseCase(repo),
  forfeitMatchUseCase: ForfeitMatchUseCase(repo),
  getMediaTokenUseCase: GetMediaTokenUseCase(repo),
  nextQuestionUseCase: NextQuestionUseCase(repo),
  adjustScoreUseCase: AdjustScoreUseCase(repo),
  sessionPrefs: prefs,
);

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  late MatchSessionPrefs prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = MatchSessionPrefs(await SharedPreferences.getInstance());
  });

  test('reopening the app goes back to the same match, same seat', () async {
    final repo = _FakeRepo();
    final first = _bloc(repo, prefs)
      ..add(
        const MatchEnterRequested(
          name: 'تميم',
          role: JoinRole.player,
          mode: MatchMode.sameRoom,
        ),
      );
    await _settle();
    expect(first.state, isA<MatchInRoom>());
    expect(prefs.get()?.code, '555111');
    await first.close(); // the app is closed

    final reopened = _bloc(repo, prefs)..add(const MatchResumeRequested());
    await _settle();
    expect(repo.joins.last, ('555111', JoinRole.player, 'تميم'));
    expect(reopened.state, isA<MatchInRoom>());
    await reopened.close();
  });

  test('a finished match is forgotten', () async {
    final repo = _FakeRepo();
    final bloc = _bloc(repo, prefs)
      ..add(
        const MatchEnterRequested(
          name: 'تميم',
          role: JoinRole.player,
          mode: MatchMode.sameRoom,
          code: 'final',
        ),
      );
    await _settle();
    expect(prefs.get()?.code, 'final');
    repo.push('final', status: 'finished');
    await _settle();
    expect(prefs.get(), isNull);
    await bloc.close();
  });

  test('leaving forgets the match; a closed match reports it', () async {
    final repo = _FakeRepo();
    final bloc = _bloc(repo, prefs)
      ..add(
        const MatchEnterRequested(
          name: 'الحكم',
          role: JoinRole.referee,
          mode: MatchMode.sameRoom,
          code: 'abc',
        ),
      );
    await _settle();
    bloc.add(const MatchLeft());
    await _settle();
    expect(prefs.get(), isNull);
    await bloc.close();

    await prefs.save(
      const MatchSession(code: 'gone', role: JoinRole.player, name: 'x'),
    );
    repo.matchExists = false;
    final resumed = _bloc(repo, prefs)..add(const MatchResumeRequested());
    await _settle();
    expect((resumed.state as MatchIdle).error, 'match_closed');
    expect(prefs.get(), isNull);
    await resumed.close();
  });
}
