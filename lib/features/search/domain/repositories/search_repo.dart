import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../quran/domain/models/surah_model.dart';
import '../models/search_results_model.dart';

abstract class SearchRepo {
  /// Searches the whole Quran, or only surah [surahNumber] when given.
  Future<Either<Failure, SearchResultsModel>> search(
    String query, {
    int? surahNumber,
  });

  /// The surahs the search can be filtered by.
  Future<Either<Failure, List<SurahModel>>> getSurahs();
}
