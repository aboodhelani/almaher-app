import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../models/mutashabihat_model.dart';
import '../models/similar_ayahs_model.dart';

abstract class MutashabihatRepo {
  Future<Either<Failure, MutashabihatModel>> getColoring(int minWords);

  Future<Either<Failure, SimilarAyahsModel>> getSimilarAyahs(
    String ayahKey,
    int minWords,
  );
}
