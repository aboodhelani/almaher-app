part of 'bookmarks_bloc.dart';

abstract class BookmarksEvent {
  const BookmarksEvent();
}

class BookmarksStarted extends BookmarksEvent {
  const BookmarksStarted();
}

/// Saves the page in a group: [groupId] (null for the default group), or a
/// new group named [newGroupName].
class BookmarkSaved extends BookmarksEvent {
  final BookmarkModel bookmark;
  final String? groupId;
  final String? newGroupName;

  const BookmarkSaved(this.bookmark, {this.groupId, this.newGroupName});
}

/// Saves the page, or unsaves it if it is already saved (keeps its group).
class BookmarkToggled extends BookmarksEvent {
  final BookmarkModel bookmark;

  const BookmarkToggled(this.bookmark);
}

class BookmarkRemoved extends BookmarksEvent {
  final int page;

  const BookmarkRemoved(this.page);
}

class BookmarkGroupCreated extends BookmarksEvent {
  final String name;

  const BookmarkGroupCreated(this.name);
}

class BookmarkGroupDeleted extends BookmarksEvent {
  final String id;

  const BookmarkGroupDeleted(this.id);
}
