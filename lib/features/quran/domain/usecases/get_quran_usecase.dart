import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/quran_model.dart';
import '../repositories/quran_repo.dart';

class GetQuranUseCase extends UseCase<QuranModel, NoParams> {
  final QuranRepo repository;

  GetQuranUseCase(this.repository);

  @override
  Future<Either<Failure, QuranModel>> call(NoParams params) {
    return repository.getQuran();
  }
}
