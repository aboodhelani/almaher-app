import 'package:flutter/foundation.dart';

import '../../../../../core/network/error/exceptions.dart';
import '../../../../quran/data/data_sources/local/quran_local_data_source.dart';
import '../../../domain/models/mutashabihat_model.dart';
import '../../../domain/models/similar_ayahs_model.dart';
import 'mutashabihat_index.dart';

/// Finds repeated ayahs and phrases in the bundled text. The index for the
/// current minimum is built off the UI thread and kept in memory.
class MutashabihatLocalDataSource {
  final QuranLocalDataSource _quranDataSource;
  Future<MutashabihatIndex>? _index;
  int? _indexMinWords;

  MutashabihatLocalDataSource(this._quranDataSource);

  Future<MutashabihatModel> getColoring(int minWords) async {
    final index = await _indexFor(minWords);
    return compute(_coloring, index);
  }

  Future<SimilarAyahsModel> getSimilarAyahs(
    String ayahKey,
    int minWords,
  ) async {
    final index = await _indexFor(minWords);
    return index.similarTo(ayahKey);
  }

  Future<MutashabihatIndex> _indexFor(int minWords) async {
    try {
      if (_index == null || _indexMinWords != minWords) {
        _indexMinWords = minWords;
        _index = _quranDataSource.getQuran().then(
          (quran) => compute(MutashabihatIndex.build, (quran, minWords)),
        );
      }
      return await _index!;
    } catch (e) {
      _index = null;
      throw CacheException(e.toString());
    }
  }
}

MutashabihatModel _coloring(MutashabihatIndex index) => index.coloring();
