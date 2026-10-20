part of 'bookmarks_bloc.dart';

class BookmarksState {
  /// Newest first.
  final List<BookmarkModel> bookmarks;

  /// Named groups, in the order they were created.
  final List<BookmarkGroupModel> groups;

  const BookmarksState({this.bookmarks = const [], this.groups = const []});

  bool isSaved(int page) => bookmarks.any((b) => b.page == page);

  /// Pages of a group (null: the default group, which also takes pages of a
  /// group that no longer exists).
  List<BookmarkModel> inGroup(String? groupId) => [
    for (final b in bookmarks)
      if (groupId == null
          ? b.groupId == null || !groups.any((g) => g.id == b.groupId)
          : b.groupId == groupId)
        b,
  ];
}
