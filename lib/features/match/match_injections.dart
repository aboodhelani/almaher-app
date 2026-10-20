import '../../core/utils/game_sounds.dart';
import '../../core/utils/injections.dart';
import '../auth/data/data_sources/local/auth_local_data_source.dart';
import 'data/data_sources/remote/match_rules_remote_data_source.dart';
import 'data/data_sources/local/match_session_prefs.dart';
import 'data/data_sources/remote/match_socket_data_source.dart';
import 'data/repositories/match_repo_impl.dart';
import 'domain/usecases/get_match_rules_usecase.dart';
import 'domain/repositories/match_repo.dart';
import 'domain/usecases/match_usecases.dart';
import 'presentation/bloc/match_bloc.dart';

void initMatchInjections() {
  sl.registerLazySingleton<GameSounds>(() => GameSounds(sl()));
  sl.registerSingleton<MatchSessionPrefs>(MatchSessionPrefs(sl()));
  // One connection per match screen, so these are factories.
  sl.registerFactory<MatchSocketDataSource>(
    () => MatchSocketDataSource(token: sl<AuthLocalDataSource>().token),
  );
  sl.registerSingleton<GetMatchRulesUseCase>(
    GetMatchRulesUseCase(MatchRulesRemoteDataSource()),
  );
  sl.registerFactory<MatchRepo>(
    () => MatchRepoImpl(sl<MatchSocketDataSource>()),
  );
  sl.registerFactory<MatchBloc>(() {
    final repo = sl<MatchRepo>();
    return MatchBloc(
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
      getMediaTokenUseCase: GetMediaTokenUseCase(repo),
      nextQuestionUseCase: NextQuestionUseCase(repo),
      adjustScoreUseCase: AdjustScoreUseCase(repo),
      sessionPrefs: sl<MatchSessionPrefs>(),
    );
  });
}
