import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../domain/models/bookmark_group_model.dart';
import '../../domain/models/bookmark_model.dart';
import '../../domain/repositories/bookmarks_repo.dart';
import '../data_sources/local/bookmarks_local_data_source.dart';

class BookmarksRepoImpl implements BookmarksRepo {
  final BookmarksLocalDataSource _local;

  BookmarksRepoImpl(this._local);

  @override
  Future<Either<Failure, List<BookmarkModel>>> getBookmarks() async {
    try {
      return Right(_local.getAll());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkModel>>> save(
    BookmarkModel bookmark,
  ) async {
    try {
      final list = [
        bookmark,
        ..._local.getAll().where((b) => b.page != bookmark.page),
      ];
      await _local.saveAll(list);
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkGroupModel>>> getGroups() async {
    try {
      return Right(_local.getGroups());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookmarkGroupModel>> createGroup(String name) async {
    try {
      final group = BookmarkGroupModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.trim(),
      );
      await _local.saveGroups([..._local.getGroups(), group]);
      return Right(group);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String id) async {
    try {
      await _local.saveGroups(_local.getGroups().where((g) => g.id != id).toList());
      await _local.saveAll([
        for (final b in _local.getAll()) b.groupId == id ? b.inGroup(null) : b,
      ]);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkModel>>> remove(int page) async {
    try {
      final list = _local.getAll().where((b) => b.page != page).toList();
      await _local.saveAll(list);
      return Right(list);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
