import 'package:flutter/foundation.dart';

import '../../../../../core/network/error/exceptions.dart';
import '../../../../quran/data/data_sources/local/quran_local_data_source.dart';
import '../../../../quran/domain/models/surah_model.dart';
import '../../../domain/models/search_results_model.dart';
import 'quran_search_index.dart';

/// Searches the bundled Quran text. The index is built on first use, off the
/// UI thread, then kept in memory.
class SearchLocalDataSource {
  final QuranLocalDataSource _quranDataSource;
  Future<QuranSearchIndex>? _index;

  SearchLocalDataSource(this._quranDataSource);

  Future<SearchResultsModel> search(String query, {int? surahNumber}) async {
    try {
      final index = await (_index ??= _buildIndex());
      return index.search(query, surahNumber: surahNumber);
    } catch (e) {
      _index = null;
      throw CacheException(e.toString());
    }
  }

  Future<List<SurahModel>> getSurahs() async {
    return (await _quranDataSource.getQuran()).surahs;
  }

  Future<QuranSearchIndex> _buildIndex() async {
    final quran = await _quranDataSource.getQuran();
    return compute(QuranSearchIndex.build, quran);
  }
}
