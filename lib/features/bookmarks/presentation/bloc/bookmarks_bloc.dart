import 'package:bloc/bloc.dart';

import '../../../../core/utils/usecases/usecase.dart';
import '../../domain/models/bookmark_group_model.dart';
import '../../domain/models/bookmark_model.dart';
import '../../domain/usecases/bookmarks_usecases.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

/// Saved pages and their groups, shared by the reader (save / unsave) and
/// the saved-pages screen. Lives for the whole app.
class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final GetBookmarksUseCase getBookmarksUseCase;
  final SaveBookmarkUseCase saveBookmarkUseCase;
  final RemoveBookmarkUseCase removeBookmarkUseCase;
  final GetBookmarkGroupsUseCase getGroupsUseCase;
  final CreateBookmarkGroupUseCase createGroupUseCase;
  final DeleteBookmarkGroupUseCase deleteGroupUseCase;

  BookmarksBloc({
    required this.getBookmarksUseCase,
    required this.saveBookmarkUseCase,
    required this.removeBookmarkUseCase,
    required this.getGroupsUseCase,
    required this.createGroupUseCase,
    required this.deleteGroupUseCase,
  }) : super(const BookmarksState()) {
    on<BookmarksStarted>((e, emit) => _reload(emit));
    on<BookmarkSaved>((e, emit) async {
      var groupId = e.groupId;
      final newName = e.newGroupName?.trim();
      if (newName != null && newName.isNotEmpty) {
        final created = await createGroupUseCase.call(newName);
        groupId = created.fold((_) => null, (g) => g.id);
      }
      await saveBookmarkUseCase.call(e.bookmark.inGroup(groupId));
      await _reload(emit);
    });
    on<BookmarkToggled>((e, emit) async {
      if (state.isSaved(e.bookmark.page)) {
        await removeBookmarkUseCase.call(e.bookmark.page);
      } else {
        await saveBookmarkUseCase.call(e.bookmark);
      }
      await _reload(emit);
    });
    on<BookmarkRemoved>((e, emit) async {
      await removeBookmarkUseCase.call(e.page);
      await _reload(emit);
    });
    on<BookmarkGroupCreated>((e, emit) async {
      if (e.name.trim().isEmpty) return;
      await createGroupUseCase.call(e.name);
      await _reload(emit);
    });
    on<BookmarkGroupDeleted>((e, emit) async {
      await deleteGroupUseCase.call(e.id);
      await _reload(emit);
    });
  }

  Future<void> _reload(Emitter<BookmarksState> emit) async {
    final bookmarks = await getBookmarksUseCase.call(NoParams());
    final groups = await getGroupsUseCase.call(NoParams());
    emit(BookmarksState(
      bookmarks: bookmarks.fold((_) => state.bookmarks, (l) => l),
      groups: groups.fold((_) => state.groups, (l) => l),
    ));
  }
}
