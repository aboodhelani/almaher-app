import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/bookmark_group_model.dart';
import '../models/bookmark_model.dart';
import '../repositories/bookmarks_repo.dart';

class GetBookmarksUseCase extends UseCase<List<BookmarkModel>, NoParams> {
  final BookmarksRepo repository;

  GetBookmarksUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookmarkModel>>> call(NoParams params) =>
      repository.getBookmarks();
}

class SaveBookmarkUseCase extends UseCase<List<BookmarkModel>, BookmarkModel> {
  final BookmarksRepo repository;

  SaveBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookmarkModel>>> call(BookmarkModel params) =>
      repository.save(params);
}

class RemoveBookmarkUseCase extends UseCase<List<BookmarkModel>, int> {
  final BookmarksRepo repository;

  RemoveBookmarkUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookmarkModel>>> call(int params) =>
      repository.remove(params);
}

class GetBookmarkGroupsUseCase extends UseCase<List<BookmarkGroupModel>, NoParams> {
  final BookmarksRepo repository;

  GetBookmarkGroupsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookmarkGroupModel>>> call(NoParams params) =>
      repository.getGroups();
}

/// Params: the group's name.
class CreateBookmarkGroupUseCase extends UseCase<BookmarkGroupModel, String> {
  final BookmarksRepo repository;

  CreateBookmarkGroupUseCase(this.repository);

  @override
  Future<Either<Failure, BookmarkGroupModel>> call(String params) =>
      repository.createGroup(params);
}

/// Params: the group's id. Its pages move to the default group.
class DeleteBookmarkGroupUseCase extends UseCase<void, String> {
  final BookmarksRepo repository;

  DeleteBookmarkGroupUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) =>
      repository.deleteGroup(params);
}
