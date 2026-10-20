import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../models/quran_model.dart';

abstract class QuranRepo {
  Future<Either<Failure, QuranModel>> getQuran();

  Future<Either<Failure, int>> getLastReadPage();

  Future<Either<Failure, void>> saveLastReadPage(int page);
}
