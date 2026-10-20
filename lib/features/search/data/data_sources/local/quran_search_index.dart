import '../../../../quran/domain/models/ayah_model.dart';
import '../../../../quran/domain/models/quran_model.dart';
import '../../../../quran/domain/models/surah_model.dart';
import '../../../domain/models/search_results_model.dart';
import 'search_text.dart';

/// The whole Quran pre-parsed for search. Build once, query many times.
class QuranSearchIndex {
  /// Text queries shorter than this (in letters) return nothing.
  static const minQueryLetters = 2;

  final List<SurahModel> _surahs;
  final List<SearchText> _surahNames;

  /// All ayahs in mushaf order, so each surah's ayahs are contiguous.
  final List<AyahModel> _ayahs;
  final List<SearchText> _ayahTexts;

  /// Index in [_ayahs] of each surah's first ayah.
  final List<int> _surahStart;
  final SearchText _surahWord = SearchText.parse('سورة', query: true);

  QuranSearchIndex._(
    this._surahs,
    this._surahNames,
    this._ayahs,
    this._ayahTexts,
    this._surahStart,
  );

  factory QuranSearchIndex.build(QuranModel quran) {
    final ayahs = [for (final page in quran.pages) ...page.ayahs];
    final surahStart = List<int>.filled(quran.surahs.length, 0);
    for (var i = ayahs.length - 1; i >= 0; i--) {
      surahStart[ayahs[i].surahNumber - 1] = i;
    }
    return QuranSearchIndex._(
      quran.surahs,
      [for (final s in quran.surahs) SearchText.parse(s.nameArabic)],
      ayahs,
      [for (final a in ayahs) SearchText.parse(a.text)],
      surahStart,
    );
  }

  /// Searches the whole Quran, or only surah [surahNumber]. Inside a surah, a
  /// query that is a number (Arabic or Western digits) picks that ayah.
  SearchResultsModel search(String rawQuery, {int? surahNumber}) {
    if (surahNumber != null) {
      final number = _parseNumber(rawQuery);
      if (number != null) return _ayahByNumber(rawQuery, surahNumber, number);
    }

    final query = SearchText.parse(rawQuery, query: true);
    if (query.letterCount < minQueryLetters) {
      return SearchResultsModel.empty(rawQuery);
    }
    final withTashkeel = query.hasTashkeel;

    // Surah names are only listed when searching the whole Quran.
    // "سورة البقرة" looks for the surah البقرة.
    final surahs = <SurahModel>[];
    if (surahNumber == null) {
      final surahQuery = query.withoutLeadingWord(_surahWord);
      for (var i = 0; i < _surahs.length; i++) {
        if (_surahNames[i].contains(surahQuery, matchTashkeel: false)) {
          surahs.add(_surahs[i]);
        }
      }
    }

    var from = 0;
    var to = _ayahs.length;
    if (surahNumber != null) {
      from = _surahStart[surahNumber - 1];
      to = from + _surahs[surahNumber - 1].ayahCount;
    }

    final full = <AyahSearchResult>[];
    final partial = <AyahSearchResult>[];
    for (var i = from; i < to; i++) {
      final text = _ayahTexts[i];
      if (!text.contains(query, matchTashkeel: false)) continue;
      final result = _result(i);
      if (withTashkeel && text.contains(query, matchTashkeel: true)) {
        full.add(result);
      } else {
        partial.add(result);
      }
    }

    return SearchResultsModel(
      query: rawQuery,
      queryHasTashkeel: withTashkeel,
      surahs: surahs,
      fullMatches: full,
      partialMatches: partial,
    );
  }

  SearchResultsModel _ayahByNumber(String rawQuery, int surahNumber, int n) {
    final surah = _surahs[surahNumber - 1];
    if (n < 1 || n > surah.ayahCount) return SearchResultsModel.empty(rawQuery);
    return SearchResultsModel(
      query: rawQuery,
      queryHasTashkeel: false,
      ayahByNumber: _result(_surahStart[surahNumber - 1] + n - 1),
      surahs: const [],
      fullMatches: const [],
      partialMatches: const [],
    );
  }

  AyahSearchResult _result(int i) => AyahSearchResult(
    ayah: _ayahs[i],
    surah: _surahs[_ayahs[i].surahNumber - 1],
  );
}

/// `255`, `٢٥٥` or `۲۵۵` → 255; anything else → null.
int? _parseNumber(String input) {
  final text = input.trim();
  if (text.isEmpty || text.length > 4) return null;
  var value = 0;
  for (final rune in text.runes) {
    final int digit;
    if (rune >= 0x30 && rune <= 0x39) {
      digit = rune - 0x30;
    } else if (rune >= 0x0660 && rune <= 0x0669) {
      digit = rune - 0x0660;
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      digit = rune - 0x06F0;
    } else {
      return null;
    }
    value = value * 10 + digit;
  }
  return value;
}
