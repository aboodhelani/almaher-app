import '../../core/utils/injections.dart';
import '../quran/data/data_sources/local/quran_local_data_source.dart';
import 'data/data_sources/local/mutashabihat_local_data_source.dart';
import 'data/repositories/mutashabihat_repo_impl.dart';
import 'domain/repositories/mutashabihat_repo.dart';
import 'domain/usecases/mutashabihat_usecases.dart';

void initMutashabihatInjections() {
  sl.registerSingleton<MutashabihatLocalDataSource>(
    MutashabihatLocalDataSource(sl<QuranLocalDataSource>()),
  );
  sl.registerSingleton<MutashabihatRepo>(
    MutashabihatRepoImpl(sl<MutashabihatLocalDataSource>()),
  );
  sl.registerSingleton<GetMutashabihatUseCase>(
    GetMutashabihatUseCase(sl<MutashabihatRepo>()),
  );
  sl.registerSingleton<GetSimilarAyahsUseCase>(
    GetSimilarAyahsUseCase(sl<MutashabihatRepo>()),
  );
}
