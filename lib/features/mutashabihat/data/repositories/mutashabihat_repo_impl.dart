import 'package:dartz/dartz.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/models/mutashabihat_model.dart';
import '../../domain/models/similar_ayahs_model.dart';
import '../../domain/repositories/mutashabihat_repo.dart';
import '../data_sources/local/mutashabihat_local_data_source.dart';

class MutashabihatRepoImpl implements MutashabihatRepo {
  final MutashabihatLocalDataSource _localDataSource;

  MutashabihatRepoImpl(this._localDataSource);

  @override
  Future<Either<Failure, MutashabihatModel>> getColoring(int minWords) async {
    try {
      return Right(await _localDataSource.getColoring(minWords));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SimilarAyahsModel>> getSimilarAyahs(
    String ayahKey,
    int minWords,
  ) async {
    try {
      return Right(await _localDataSource.getSimilarAyahs(ayahKey, minWords));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
