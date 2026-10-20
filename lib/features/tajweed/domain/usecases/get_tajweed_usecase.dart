import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/tajweed_model.dart';
import '../repositories/tajweed_repo.dart';

class GetTajweedUseCase extends UseCase<TajweedModel, NoParams> {
  final TajweedRepo repository;

  GetTajweedUseCase(this.repository);

  @override
  Future<Either<Failure, TajweedModel>> call(NoParams params) {
    return repository.getTajweed();
  }
}
