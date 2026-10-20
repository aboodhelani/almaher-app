import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../../core/network/error/exceptions.dart';
import '../../../../../core/utils/constant/app_constants.dart';
import '../../../domain/models/ayah_model.dart';
import '../../../domain/models/mushaf_line_model.dart';
import '../../../domain/models/quran_model.dart';
import '../../../domain/models/quran_page_model.dart';
import '../../../domain/models/surah_model.dart';

/// Reads the bundled Quran text. Parsed once, then held in memory.
class QuranLocalDataSource {
  QuranModel? _cache;

  Future<QuranModel> getQuran() async {
    final cached = _cache;
    if (cached != null) return cached;
    try {
      final raw = await rootBundle.loadString(quranAssetPath);
      final layout = await rootBundle.loadString(mushafLayoutAssetPath);
      // ~1.7 MB of JSON — parse off the UI thread.
      final quran = await compute(parseQuranJson, (raw, layout));
      _cache = quran;
      return quran;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}

/// Builds the [QuranModel] from the bundled JSON (see assets/quran): the
/// text, and — when given — the mushaf's line layout.
QuranModel parseQuranJson((String, String?) input) {
  final (raw, layoutRaw) = input;
  final json = jsonDecode(raw) as Map<String, dynamic>;
  final surahs = (json['surahs'] as List)
      .map((s) => SurahModel.fromJson(s as Map<String, dynamic>))
      .toList(growable: false);

  final byPage = List.generate(quranTotalPages, (_) => <AyahModel>[]);
  for (final row in json['ayahs'] as List) {
    final ayah = AyahModel.fromRow(row as List);
    byPage[ayah.page - 1].add(ayah);
  }

  final byKey = {
    for (final page in byPage)
      for (final ayah in page) ayah.key: ayah,
  };
  final layout = layoutRaw == null
      ? null
      : (jsonDecode(layoutRaw) as Map<String, dynamic>)['pages'] as List;
  final pages = [
    for (var i = 0; i < quranTotalPages; i++)
      QuranPageModel(
        pageNumber: i + 1,
        ayahs: byPage[i],
        lines: layout == null ? const [] : _parseLines(layout[i] as List, byKey),
      ),
  ];
  return QuranModel(surahs: surahs, pages: pages);
}

/// A page's lines from the layout: ["h", surah], ["b"], or text segments
/// [surah, ayah, fromWord, toWord, endsAyah].
List<MushafLineModel> _parseLines(
  List<dynamic> lines,
  Map<String, AyahModel> byKey,
) => [
  for (final line in lines.cast<List<dynamic>>())
    if (line.first == 'h')
      SurahBannerLine(line[1] as int)
    else if (line.first == 'b')
      const BasmalaLine()
    else
      TextLine([
        for (final seg in line.cast<List<dynamic>>())
          LineSegmentModel(
            ayah: byKey['${seg[0]}:${seg[1]}']!,
            fromWord: seg[2] as int,
            toWord: seg[3] as int,
            endsAyah: seg[4] == 1,
          ),
      ]),
];
