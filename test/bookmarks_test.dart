import 'package:almaher/features/bookmarks/data/data_sources/local/bookmarks_local_data_source.dart';
import 'package:almaher/features/bookmarks/data/repositories/bookmarks_repo_impl.dart';
import 'package:almaher/features/bookmarks/domain/models/bookmark_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

BookmarkModel _b(int page) => BookmarkModel(
  page: page,
  surahName: 'البقرة',
  juz: 1,
  savedAt: DateTime(2026, 10, 16),
);

void main() {
  test('saves pages newest first, moves a re-saved page up, removes', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = BookmarksRepoImpl(BookmarksLocalDataSource(prefs));

    await repo.save(_b(2));
    await repo.save(_b(26));
    var list = (await repo.save(_b(2))).getOrElse(() => []);
    expect(list.map((b) => b.page), [2, 26]);

    list = (await repo.remove(26)).getOrElse(() => []);
    expect(list.map((b) => b.page), [2]);

    // Survives a reload from storage.
    final reloaded = BookmarksRepoImpl(BookmarksLocalDataSource(prefs));
    final stored = (await reloaded.getBookmarks()).getOrElse(() => []);
    expect(stored.single.surahName, 'البقرة');
  });

  test('groups: save into a named group, delete it, pages go to default', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = BookmarksRepoImpl(BookmarksLocalDataSource(prefs));

    final group = (await repo.createGroup(' ختمة التهجد ')).getOrElse(
      () => throw StateError('no group'),
    );
    expect(group.name, 'ختمة التهجد');
    await repo.save(_b(2));
    await repo.save(_b(50).inGroup(group.id));
    var list = (await repo.getBookmarks()).getOrElse(() => []);
    expect({for (final b in list) b.page: b.groupId}, {50: group.id, 2: null});

    // Re-saving into another group moves the page.
    list = (await repo.save(_b(50))).getOrElse(() => []);
    expect(list.firstWhere((b) => b.page == 50).groupId, isNull);

    await repo.save(_b(77).inGroup(group.id));
    await repo.deleteGroup(group.id);
    expect((await repo.getGroups()).getOrElse(() => []), isEmpty);
    list = (await repo.getBookmarks()).getOrElse(() => []);
    expect(list.every((b) => b.groupId == null), isTrue);
  });
}
