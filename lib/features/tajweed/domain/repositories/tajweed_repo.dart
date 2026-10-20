import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../models/tajweed_model.dart';

abstract class TajweedRepo {
  Future<Either<Failure, TajweedModel>> getTajweed();
}
