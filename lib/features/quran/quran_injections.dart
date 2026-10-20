import '../../core/utils/injections.dart';
import 'data/data_sources/local/quran_local_data_source.dart';
import 'data/data_sources/local/quran_shared_prefs.dart';
import 'data/repositories/quran_repo_impl.dart';
import 'domain/repositories/quran_repo.dart';
import '../mutashabihat/domain/usecases/get_mutashabihat_usecase.dart';
import '../tajweed/domain/usecases/get_tajweed_usecase.dart';
import 'domain/usecases/quran_usecases.dart';
import 'presentation/bloc/quran_bloc.dart';

void initQuranInjections() {
  sl.registerSingleton<QuranLocalDataSource>(QuranLocalDataSource());
  sl.registerSingleton<QuranSharedPrefs>(QuranSharedPrefs(sl()));
  sl.registerSingleton<QuranRepo>(
    QuranRepoImpl(sl<QuranLocalDataSource>(), sl<QuranSharedPrefs>()),
  );
  sl.registerSingleton<GetQuranUseCase>(GetQuranUseCase(sl<QuranRepo>()));
  sl.registerSingleton<GetLastReadPageUseCase>(
    GetLastReadPageUseCase(sl<QuranRepo>()),
  );
  sl.registerSingleton<SaveLastReadPageUseCase>(
    SaveLastReadPageUseCase(sl<QuranRepo>()),
  );
  sl.registerFactory<QuranBloc>(
    () => QuranBloc(
      getQuranUseCase: sl<GetQuranUseCase>(),
      getLastReadPageUseCase: sl<GetLastReadPageUseCase>(),
      saveLastReadPageUseCase: sl<SaveLastReadPageUseCase>(),
      getTajweedUseCase: sl<GetTajweedUseCase>(),
      getMutashabihatUseCase: sl<GetMutashabihatUseCase>(),
    ),
  );
}
