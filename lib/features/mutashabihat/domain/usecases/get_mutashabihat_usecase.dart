import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/mutashabihat_model.dart';
import '../repositories/mutashabihat_repo.dart';

/// Colouring of repeated ayahs; the param is the minimum shared words.
class GetMutashabihatUseCase extends UseCase<MutashabihatModel, int> {
  final MutashabihatRepo repository;

  GetMutashabihatUseCase(this.repository);

  @override
  Future<Either<Failure, MutashabihatModel>> call(int params) {
    return repository.getColoring(params);
  }
}
