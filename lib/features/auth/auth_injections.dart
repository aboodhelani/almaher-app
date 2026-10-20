import '../../core/utils/injections.dart';
import 'data/data_sources/local/auth_local_data_source.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repo_impl.dart';
import 'domain/repositories/auth_repo.dart';
import 'domain/usecases/auth_usecases.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/profile_bloc.dart';

void initAuthInjections() {
  sl.registerSingleton<AuthLocalDataSource>(AuthLocalDataSource(sl()));
  sl.registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSource());
  sl.registerSingleton<AuthRepo>(
    AuthRepoImpl(sl<AuthRemoteDataSource>(), sl<AuthLocalDataSource>()),
  );
  sl.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(sl<AuthRepo>()),
  );
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl<AuthRepo>()));
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase(sl<AuthRepo>()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl<AuthRepo>()));
  sl.registerSingleton<DeleteAccountUseCase>(
    DeleteAccountUseCase(sl<AuthRepo>()),
  );
  sl.registerSingleton<GetProfileUseCase>(GetProfileUseCase(sl<AuthRepo>()));
  sl.registerSingleton<GetLeaderboardUseCase>(
    GetLeaderboardUseCase(sl<AuthRepo>()),
  );
  // One for the app: home, the competition and the profile share it.
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    )..add(const AuthStarted()),
  );
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: sl<GetProfileUseCase>(),
      getLeaderboardUseCase: sl<GetLeaderboardUseCase>(),
    ),
  );
}
