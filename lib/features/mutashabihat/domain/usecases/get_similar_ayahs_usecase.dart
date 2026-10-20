import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/similar_ayahs_model.dart';
import '../repositories/mutashabihat_repo.dart';

class GetSimilarAyahsUseCase
    extends UseCase<SimilarAyahsModel, SimilarAyahsParams> {
  final MutashabihatRepo repository;

  GetSimilarAyahsUseCase(this.repository);

  @override
  Future<Either<Failure, SimilarAyahsModel>> call(SimilarAyahsParams params) {
    return repository.getSimilarAyahs(params.ayahKey, params.minWords);
  }
}

class SimilarAyahsParams extends Equatable {
  final String ayahKey;
  final int minWords;

  const SimilarAyahsParams({required this.ayahKey, required this.minWords});

  @override
  List<Object?> get props => [ayahKey, minWords];
}
