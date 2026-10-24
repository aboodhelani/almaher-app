import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../data/data_sources/local/match_session_prefs.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';
import '../../domain/repositories/match_repo.dart';
import '../../domain/usecases/match_usecases.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepo repo;
  final CreateMatchUseCase createMatchUseCase;
  final JoinMatchUseCase joinMatchUseCase;
  final QuickMatchUseCase quickMatchUseCase;
  final StartMatchUseCase startMatchUseCase;
  final BuzzUseCase buzzUseCase;
  final PassBidUseCase passBidUseCase;
  final AnswerSideUseCase answerSideUseCase;
  final StartRunUseCase startRunUseCase;
  final GetSetupQuestionsUseCase getSetupQuestionsUseCase;
  final SetRoundCountsUseCase setRoundCountsUseCase;
  final SetRoundQuestionsUseCase setRoundQuestionsUseCase;
  final PublishMatchUseCase publishMatchUseCase;
  final JudgeAnswerUseCase judgeAnswerUseCase;
  final AwardPointUseCase awardPointUseCase;
  final SubmitAnswerUseCase submitAnswerUseCase;
  final RevealAnswersUseCase revealAnswersUseCase;
  final ReplaceQuestionUseCase replaceQuestionUseCase;
  final EndMatchUseCase endMatchUseCase;
  final ForfeitQuestionUseCase forfeitQuestionUseCase;
  final ForfeitMatchUseCase forfeitMatchUseCase;
  final GetMediaTokenUseCase getMediaTokenUseCase;
  final NextQuestionUseCase nextQuestionUseCase;
  final AdjustScoreUseCase adjustScoreUseCase;
  final MatchSessionPrefs sessionPrefs;

  StreamSubscription<MatchStateModel>? _states;

  /// Who this device entered as, to remember the session once in the room.
  JoinRole? _role;
  String? _name;

  MatchBloc({
    required this.repo,
    required this.createMatchUseCase,
    required this.joinMatchUseCase,
    required this.quickMatchUseCase,
    required this.startMatchUseCase,
    required this.buzzUseCase,
    required this.passBidUseCase,
    required this.answerSideUseCase,
    required this.startRunUseCase,
    required this.getSetupQuestionsUseCase,
    required this.setRoundCountsUseCase,
    required this.setRoundQuestionsUseCase,
    required this.publishMatchUseCase,
    required this.judgeAnswerUseCase,
    required this.awardPointUseCase,
    required this.submitAnswerUseCase,
    required this.revealAnswersUseCase,
    required this.replaceQuestionUseCase,
    required this.endMatchUseCase,
    required this.forfeitQuestionUseCase,
    required this.forfeitMatchUseCase,
    required this.getMediaTokenUseCase,
    required this.nextQuestionUseCase,
    required this.adjustScoreUseCase,
    required this.sessionPrefs,
  }) : super(const MatchIdle()) {
    on<MatchResumeRequested>(_onResume);
    on<MatchEnterRequested>(_onEnter);
    on<MatchStateReceived>(_onState);
    on<MatchStartRequested>(
      (e, emit) => _act(emit, () => startMatchUseCase.call(NoParams())),
    );
    on<MatchBuzzed>(
      (e, emit) => _act(emit, () => buzzUseCase.call(NoParams())),
    );
    on<MatchJudged>(
      (e, emit) => _act(
        emit,
        () => judgeAnswerUseCase.call(
          JudgeParams(correct: e.correct, ref: e.ref, player: e.player),
        ),
      ),
    );
    on<MatchRoundCountsSet>(
      (e, emit) => _act(emit, () => setRoundCountsUseCase.call(e.counts)),
    );
    on<MatchRoundQuestionsSet>(
      (e, emit) => _act(
        emit,
        () => setRoundQuestionsUseCase.call(
          RoundQuestionsParams(e.type, e.questions),
        ),
      ),
    );
    on<MatchPublishRequested>(
      (e, emit) => _act(emit, () => publishMatchUseCase.call(NoParams())),
    );
    on<MatchSideAnswered>(
      (e, emit) => _act(emit, () => answerSideUseCase.call(e.right)),
    );
    on<MatchRunStarted>(
      (e, emit) => _act(emit, () => startRunUseCase.call(NoParams())),
    );
    on<MatchBidPassed>(
      (e, emit) => _act(emit, () => passBidUseCase.call(NoParams())),
    );
    on<MatchPointAwarded>(
      (e, emit) => _act(emit, () => awardPointUseCase.call(e.player)),
    );
    on<MatchAnswerSubmitted>(
      (e, emit) => _act(emit, () => submitAnswerUseCase.call(e.value)),
    );
    on<MatchReplaceRequested>(
      (e, emit) => _act(emit, () => replaceQuestionUseCase.call(NoParams())),
    );
    on<MatchEndRequested>(
      (e, emit) => _act(emit, () => endMatchUseCase.call(NoParams())),
    );
    on<MatchQuestionForfeited>(
      (e, emit) => _act(emit, () => forfeitQuestionUseCase.call(NoParams())),
    );
    on<MatchForfeited>(
      (e, emit) => _act(emit, () => forfeitMatchUseCase.call(NoParams())),
    );
    on<MatchRevealRequested>(
      (e, emit) => _act(emit, () => revealAnswersUseCase.call(NoParams())),
    );
    on<MatchNextRequested>(
      (e, emit) => _act(emit, () => nextQuestionUseCase.call(NoParams())),
    );
    on<MatchScoreAdjusted>(
      (e, emit) => _act(
        emit,
        () => adjustScoreUseCase.call(AdjustScoreParams(e.player, e.delta)),
      ),
    );
    on<MatchLeft>(_onLeft);
    on<MatchErrorShown>((e, emit) {
      final s = state;
      if (s is MatchInRoom) emit(MatchInRoom(s.match));
    });
  }

  /// With an ID: joins that exact match, creating it under that ID if it
  /// does not exist yet. Without one: the server matches the user.
  /// Remote matches: a token for the audio/video room, over this screen's
  /// connection (the server knows our seat).
  Future<Either<Failure, MediaTokenModel>> mediaToken() =>
      getMediaTokenUseCase.call(NoParams());

  /// Referee, preparing: questions to pick from (the bank, or generated).
  Future<Either<Failure, List<QuestionModel>>> setupQuestions(
    RoundType type, {
    bool generated = false,
  }) => getSetupQuestionsUseCase.call(
    SetupQuestionsParams(type, generated: generated),
  );

  Future<void> _onEnter(
    MatchEnterRequested event,
    Emitter<MatchState> emit,
  ) async {
    emit(const MatchConnecting());
    _states ??= repo.states.listen((s) => add(MatchStateReceived(s)));
    final name = event.name.trim();
    final code = event.code?.trim();
    _role = event.role;
    _name = name;

    if (code == null || code.isEmpty) {
      final matched = await quickMatchUseCase.call(
        QuickMatchParams(role: event.role, name: name, mode: event.mode),
      );
      matched.fold((f) => emit(MatchIdle(error: f.errorMessage)), (_) {});
      return;
    }

    var joined = await _join(code, event.role, name);
    final notFound = joined.fold(
      (f) => f.errorMessage == 'match_not_found',
      (_) => false,
    );
    if (notFound) {
      final created = await createMatchUseCase.call(
        CreateMatchParams(
          mode: event.mode,
          code: code,
          asReferee: event.role == JoinRole.referee,
        ),
      );
      final createdCode = created.fold((f) => null, (c) => c);
      if (createdCode == null) {
        created.fold((f) => emit(MatchIdle(error: f.errorMessage)), (_) {});
        return;
      }
      joined = await _join(createdCode, event.role, name);
    }
    // On success the server's first snapshot moves us into the room.
    joined.fold((f) => emit(MatchIdle(error: f.errorMessage)), (_) {});
  }

  Future<Either<Failure, void>> _join(String code, JoinRole role, String name) {
    return joinMatchUseCase.call(
      JoinMatchParams(code: code, role: role, name: name),
    );
  }

  /// Runs an in-room action; a refusal is shown without leaving the room.
  Future<void> _act(
    Emitter<MatchState> emit,
    Future<Either<Failure, void>> Function() action,
  ) async {
    final result = await action();
    result.fold((f) {
      final s = state;
      if (s is MatchInRoom) emit(MatchInRoom(s.match, error: f.errorMessage));
    }, (_) {});
  }

  /// Reopens the match this device was in (the app was closed or left).
  Future<void> _onResume(
    MatchResumeRequested event,
    Emitter<MatchState> emit,
  ) async {
    final session = sessionPrefs.get();
    if (session == null) return;
    emit(const MatchConnecting());
    _states ??= repo.states.listen((s) => add(MatchStateReceived(s)));
    _role = session.role;
    _name = session.name;
    final joined = await _join(session.code, session.role, session.name);
    await joined.fold((f) async {
      // The match ended or closed while away: start fresh.
      if (f.errorMessage != 'unreachable' && f.errorMessage != 'timeout') {
        await sessionPrefs.clear();
      }
      emit(
        MatchIdle(
          error: f.errorMessage == 'match_not_found'
              ? 'match_closed'
              : f.errorMessage,
        ),
      );
    }, (_) async {});
  }

  Future<void> _onState(MatchStateReceived e, Emitter<MatchState> emit) async {
    final match = e.state;
    if (match.status == MatchStatus.finished) {
      await sessionPrefs.clear();
    } else if (_role != null && _name != null) {
      await sessionPrefs.save(
        MatchSession(code: match.code, role: _role!, name: _name!),
      );
    }
    emit(MatchInRoom(match));
  }

  Future<void> _onLeft(MatchLeft event, Emitter<MatchState> emit) async {
    await sessionPrefs.clear();
    await _states?.cancel();
    _states = null;
    await repo.leave();
    emit(const MatchIdle());
  }

  @override
  Future<void> close() async {
    await _states?.cancel();
    await repo.leave();
    return super.close();
  }
}
