import '../../core/utils/injections.dart';
import 'data/data_sources/local/library_local_data_source.dart';
import 'data/data_sources/remote/library_remote_data_source.dart';
import 'data/repositories/library_repo_impl.dart';
import 'domain/repositories/library_repo.dart';
import 'domain/usecases/library_usecases.dart';
import 'presentation/bloc/library_bloc.dart';
import 'presentation/recitation_player.dart';

void initLibraryInjections() {
  sl.registerSingleton<LibraryRemoteDataSource>(LibraryRemoteDataSource());
  sl.registerSingleton<LibraryLocalDataSource>(LibraryLocalDataSource(sl()));
  sl.registerSingleton<LibraryRepo>(
    LibraryRepoImpl(sl<LibraryRemoteDataSource>(), sl<LibraryLocalDataSource>()),
  );
  sl.registerSingleton(GetLibraryCatalogUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(GetDownloadedEditionsUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(DownloadEditionUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(DeleteEditionUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(GetAyahTextUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(GetDownloadedSurahsUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(DownloadSurahUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(DeleteSurahUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(GetSurahFilesUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(GetLibrarySelectionUseCase(sl<LibraryRepo>()));
  sl.registerSingleton(SetLibrarySelectionUseCase(sl<LibraryRepo>()));
  // One for the app: downloads keep going while the user moves around.
  sl.registerLazySingleton<LibraryBloc>(
    () => LibraryBloc(
      getCatalogUseCase: sl(),
      getDownloadedEditionsUseCase: sl(),
      downloadEditionUseCase: sl(),
      deleteEditionUseCase: sl(),
      getDownloadedSurahsUseCase: sl(),
      downloadSurahUseCase: sl(),
      deleteSurahUseCase: sl(),
      getSelectionUseCase: sl(),
      setSelectionUseCase: sl(),
    )..add(const LibraryStarted()),
  );
  sl.registerLazySingleton<RecitationPlayer>(
    () => RecitationPlayer(sl<GetSurahFilesUseCase>()),
  );
}
