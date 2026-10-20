import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/search_results_model.dart';
import '../repositories/search_repo.dart';

class SearchQuranUseCase extends UseCase<SearchResultsModel, SearchParams> {
  final SearchRepo repository;

  SearchQuranUseCase(this.repository);

  @override
  Future<Either<Failure, SearchResultsModel>> call(SearchParams params) {
    return repository.search(params.query, surahNumber: params.surahNumber);
  }
}

class SearchParams extends Equatable {
  final String query;

  /// Limits the search to one surah.
  final int? surahNumber;

  const SearchParams({required this.query, this.surahNumber});

  @override
  List<Object?> get props => [query, surahNumber];
}
