import 'package:dartz/dartz.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../../quran/domain/models/surah_model.dart';
import '../../domain/models/search_results_model.dart';
import '../../domain/repositories/search_repo.dart';
import '../data_sources/local/search_local_data_source.dart';

class SearchRepoImpl implements SearchRepo {
  final SearchLocalDataSource _localDataSource;

  SearchRepoImpl(this._localDataSource);

  @override
  Future<Either<Failure, SearchResultsModel>> search(
    String query, {
    int? surahNumber,
  }) async {
    try {
      return Right(
        await _localDataSource.search(query, surahNumber: surahNumber),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<SurahModel>>> getSurahs() async {
    try {
      return Right(await _localDataSource.getSurahs());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
