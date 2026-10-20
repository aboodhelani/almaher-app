import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../repositories/quran_repo.dart';

class SaveLastReadPageUseCase extends UseCase<void, int> {
  final QuranRepo repository;

  SaveLastReadPageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int params) {
    return repository.saveLastReadPage(params);
  }
}
