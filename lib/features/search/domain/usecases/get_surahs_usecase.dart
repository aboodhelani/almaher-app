import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../../../quran/domain/models/surah_model.dart';
import '../repositories/search_repo.dart';

class GetSurahsUseCase extends UseCase<List<SurahModel>, NoParams> {
  final SearchRepo repository;

  GetSurahsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SurahModel>>> call(NoParams params) {
    return repository.getSurahs();
  }
}
