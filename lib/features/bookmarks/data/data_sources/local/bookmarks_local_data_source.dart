import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/constant/local_storage_constants.dart';
import '../../../domain/models/bookmark_group_model.dart';
import '../../../domain/models/bookmark_model.dart';

/// Saved pages, newest first, kept as JSON in shared preferences.
class BookmarksLocalDataSource {
  final SharedPreferences _preferences;

  BookmarksLocalDataSource(this._preferences);

  List<BookmarkModel> getAll() {
    final raw = _preferences.getStringList(savedPages) ?? const [];
    return [
      for (final item in raw)
        BookmarkModel.fromJson(jsonDecode(item) as Map<String, dynamic>),
    ];
  }

  /// Groups in the order they were created.
  List<BookmarkGroupModel> getGroups() => [
    for (final item in _preferences.getStringList(savedPageGroups) ?? const [])
      BookmarkGroupModel.fromJson(jsonDecode(item) as Map<String, dynamic>),
  ];

  Future<void> saveGroups(List<BookmarkGroupModel> groups) =>
      _preferences.setStringList(savedPageGroups, [
        for (final g in groups) jsonEncode(g.toJson()),
      ]);

  Future<void> saveAll(List<BookmarkModel> bookmarks) =>
      _preferences.setStringList(savedPages, [
        for (final b in bookmarks) jsonEncode(b.toJson()),
      ]);
}
