import '../../core/utils/injections.dart';
import '../quran/data/data_sources/local/quran_local_data_source.dart';
import 'data/data_sources/local/search_local_data_source.dart';
import 'data/repositories/search_repo_impl.dart';
import 'domain/repositories/search_repo.dart';
import 'domain/usecases/search_usecases.dart';
import 'presentation/bloc/search_bloc.dart';

void initSearchInjections() {
  sl.registerSingleton<SearchLocalDataSource>(
    SearchLocalDataSource(sl<QuranLocalDataSource>()),
  );
  sl.registerSingleton<SearchRepo>(SearchRepoImpl(sl<SearchLocalDataSource>()));
  sl.registerSingleton<SearchQuranUseCase>(
    SearchQuranUseCase(sl<SearchRepo>()),
  );
  sl.registerSingleton<GetSurahsUseCase>(GetSurahsUseCase(sl<SearchRepo>()));
  sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      searchQuranUseCase: sl<SearchQuranUseCase>(),
      getSurahsUseCase: sl<GetSurahsUseCase>(),
    ),
  );
}
