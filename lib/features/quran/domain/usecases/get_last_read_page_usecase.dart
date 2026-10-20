import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/quran_repo.dart';

class GetLastReadPageUseCase extends UseCase<int, NoParams> {
  final QuranRepo repository;

  GetLastReadPageUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.getLastReadPage();
  }
}
