import '../../core/utils/injections.dart';
import '../quran/data/data_sources/local/quran_local_data_source.dart';
import '../quran/domain/usecases/quran_usecases.dart';
import 'data/data_sources/local/tajweed_local_data_source.dart';
import 'data/repositories/tajweed_repo_impl.dart';
import 'domain/repositories/tajweed_repo.dart';
import 'domain/usecases/get_tajweed_usecase.dart';
import 'presentation/bloc/tajweed_guide_bloc.dart';

void initTajweedInjections() {
  sl.registerSingleton<TajweedLocalDataSource>(
    TajweedLocalDataSource(sl<QuranLocalDataSource>()),
  );
  sl.registerSingleton<TajweedRepo>(
    TajweedRepoImpl(sl<TajweedLocalDataSource>()),
  );
  sl.registerSingleton<GetTajweedUseCase>(GetTajweedUseCase(sl<TajweedRepo>()));
  sl.registerFactory<TajweedGuideBloc>(
    () => TajweedGuideBloc(
      getQuranUseCase: sl<GetQuranUseCase>(),
      getTajweedUseCase: sl<GetTajweedUseCase>(),
    ),
  );
}
