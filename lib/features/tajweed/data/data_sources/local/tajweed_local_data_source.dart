import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../../core/network/error/exceptions.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../../quran/data/data_sources/local/quran_local_data_source.dart';
import '../../../domain/models/tajweed_model.dart';
import '../../../domain/models/tajweed_rule.dart';
import '../../../domain/models/tajweed_span_model.dart';

/// Reads the bundled tajweed spans (built by tool/build_tajweed.py). Parsed
/// once, then held in memory.
class TajweedLocalDataSource {
  final QuranLocalDataSource _quranDataSource;
  TajweedModel? _cache;

  TajweedLocalDataSource(this._quranDataSource);

  Future<TajweedModel> getTajweed() async {
    final cached = _cache;
    if (cached != null) return cached;
    try {
      final quran = await _quranDataSource.getQuran();
      // The asset lists ayahs in mushaf order, like the pages do.
      final keys = [
        for (final page in quran.pages)
          for (final ayah in page.ayahs) ayah.key,
      ];
      final raw = await rootBundle.loadString(tajweedAssetPath);
      final tajweed = await compute(parseTajweedJson, (raw, keys));
      _cache = tajweed;
      return tajweed;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}

/// Builds the [TajweedModel] from the asset JSON and the ayah keys in order.
TajweedModel parseTajweedJson((String, List<String>) input) {
  final (raw, keys) = input;
  final json = jsonDecode(raw) as Map<String, dynamic>;
  final codes = json['rules'] as String;
  final rules = [for (final c in codes.split('')) TajweedRule.fromCode(c)];
  final ayahs = json['ayahs'] as List;

  final byAyah = <String, List<TajweedSpanModel>>{};
  for (var i = 0; i < ayahs.length && i < keys.length; i++) {
    final flat = ayahs[i] as List;
    final spans = <TajweedSpanModel>[];
    for (var j = 0; j + 2 < flat.length; j += 3) {
      final rule = rules[flat[j + 2] as int];
      if (rule == null) continue;
      spans.add(
        TajweedSpanModel(
          start: flat[j] as int,
          end: flat[j + 1] as int,
          rule: rule,
        ),
      );
    }
    if (spans.isNotEmpty) byAyah[keys[i]] = spans;
  }
  return TajweedModel(byAyah);
}
