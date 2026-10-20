import 'package:dartz/dartz.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/models/quran_model.dart';
import '../../domain/repositories/quran_repo.dart';
import '../data_sources/local/quran_local_data_source.dart';
import '../data_sources/local/quran_shared_prefs.dart';

class QuranRepoImpl implements QuranRepo {
  final QuranLocalDataSource _localDataSource;
  final QuranSharedPrefs _prefs;

  QuranRepoImpl(this._localDataSource, this._prefs);

  @override
  Future<Either<Failure, QuranModel>> getQuran() async {
    try {
      final result = await _localDataSource.getQuran();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getLastReadPage() async {
    try {
      return Right(_prefs.getLastReadPage());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveLastReadPage(int page) async {
    try {
      await _prefs.setLastReadPage(page);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
