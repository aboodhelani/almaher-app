import '../../core/utils/injections.dart';
import 'data/data_sources/local/bookmarks_local_data_source.dart';
import 'data/repositories/bookmarks_repo_impl.dart';
import 'domain/repositories/bookmarks_repo.dart';
import 'domain/usecases/bookmarks_usecases.dart';
import 'presentation/bloc/bookmarks_bloc.dart';

void initBookmarksInjections() {
  sl.registerSingleton<BookmarksLocalDataSource>(
    BookmarksLocalDataSource(sl()),
  );
  sl.registerSingleton<BookmarksRepo>(
    BookmarksRepoImpl(sl<BookmarksLocalDataSource>()),
  );
  sl.registerSingleton<GetBookmarksUseCase>(
    GetBookmarksUseCase(sl<BookmarksRepo>()),
  );
  sl.registerSingleton<SaveBookmarkUseCase>(
    SaveBookmarkUseCase(sl<BookmarksRepo>()),
  );
  sl.registerSingleton<RemoveBookmarkUseCase>(
    RemoveBookmarkUseCase(sl<BookmarksRepo>()),
  );
  sl.registerSingleton<GetBookmarkGroupsUseCase>(
    GetBookmarkGroupsUseCase(sl<BookmarksRepo>()),
  );
  sl.registerSingleton<CreateBookmarkGroupUseCase>(
    CreateBookmarkGroupUseCase(sl<BookmarksRepo>()),
  );
  sl.registerSingleton<DeleteBookmarkGroupUseCase>(
    DeleteBookmarkGroupUseCase(sl<BookmarksRepo>()),
  );
  // One for the app: the reader and the saved-pages screen share it.
  sl.registerLazySingleton<BookmarksBloc>(
    () => BookmarksBloc(
      getBookmarksUseCase: sl<GetBookmarksUseCase>(),
      saveBookmarkUseCase: sl<SaveBookmarkUseCase>(),
      removeBookmarkUseCase: sl<RemoveBookmarkUseCase>(),
      getGroupsUseCase: sl<GetBookmarkGroupsUseCase>(),
      createGroupUseCase: sl<CreateBookmarkGroupUseCase>(),
      deleteGroupUseCase: sl<DeleteBookmarkGroupUseCase>(),
    )..add(const BookmarksStarted()),
  );
}
