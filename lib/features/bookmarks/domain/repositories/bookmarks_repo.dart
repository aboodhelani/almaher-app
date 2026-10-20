import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../models/bookmark_group_model.dart';
import '../models/bookmark_model.dart';

abstract class BookmarksRepo {
  /// Saved pages, newest first.
  Future<Either<Failure, List<BookmarkModel>>> getBookmarks();

  /// Saves [bookmark] (moving it to the top if its page was already saved).
  Future<Either<Failure, List<BookmarkModel>>> save(BookmarkModel bookmark);

  Future<Either<Failure, List<BookmarkModel>>> remove(int page);

  /// Groups in the order they were created.
  Future<Either<Failure, List<BookmarkGroupModel>>> getGroups();

  /// Creates a group named [name] and returns it.
  Future<Either<Failure, BookmarkGroupModel>> createGroup(String name);

  /// Deletes a group; its pages move to the default group.
  Future<Either<Failure, void>> deleteGroup(String id);
}
