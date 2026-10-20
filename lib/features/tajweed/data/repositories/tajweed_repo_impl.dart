import 'package:dartz/dartz.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/models/tajweed_model.dart';
import '../../domain/repositories/tajweed_repo.dart';
import '../data_sources/local/tajweed_local_data_source.dart';

class TajweedRepoImpl implements TajweedRepo {
  final TajweedLocalDataSource _localDataSource;

  TajweedRepoImpl(this._localDataSource);

  @override
  Future<Either<Failure, TajweedModel>> getTajweed() async {
    try {
      return Right(await _localDataSource.getTajweed());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
