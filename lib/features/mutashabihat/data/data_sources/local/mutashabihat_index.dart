import '../../../../quran/domain/models/ayah_model.dart';
import '../../../../quran/domain/models/quran_model.dart';
import '../../../../quran/domain/models/surah_model.dart';
import '../../../domain/models/mutashabihat_model.dart';
import '../../../domain/models/similar_ayahs_model.dart';

/// Every ayah split into comparable words, with an index of the word runs of
/// [minWords] words that each ayah contains.
///
/// Words are compared by their letters only: tashkeel, Uthmani small letters
/// and waqf signs are ignored, and ٱ أ إ آ → ا, ى → ي, ة → ه.
class MutashabihatIndex {
  final int minWords;
  final List<SurahModel> _surahs;
  final List<AyahModel> _ayahs;
  final Map<String, int> _indexOfKey;
  final List<List<String>> _words;

  /// Character range of each word in the ayah text.
  final List<List<(int, int)>> _wordRanges;

  /// Word run (joined by spaces) → ayahs containing it, in mushaf order.
  final Map<String, List<int>> _runs;

  /// Whole ayah (joined) → ayahs with exactly that text.
  final Map<String, List<int>> _texts;

  MutashabihatIndex._(
    this.minWords,
    this._surahs,
    this._ayahs,
    this._indexOfKey,
    this._words,
    this._wordRanges,
    this._runs,
    this._texts,
  );

  factory MutashabihatIndex.build((QuranModel, int) input) {
    final (quran, minWords) = input;
    final ayahs = [for (final page in quran.pages) ...page.ayahs];
    final words = <List<String>>[];
    final ranges = <List<(int, int)>>[];
    for (final ayah in ayahs) {
      final (w, r) = _splitWords(ayah.text);
      words.add(w);
      ranges.add(r);
    }

    final runs = <String, List<int>>{};
    final texts = <String, List<int>>{};
    for (var i = 0; i < ayahs.length; i++) {
      final w = words[i];
      texts.putIfAbsent(w.join(' '), () => []).add(i);
      for (var j = 0; j + minWords <= w.length; j++) {
        final list = runs.putIfAbsent(_run(w, j, minWords), () => []);
        if (list.isEmpty || list.last != i) list.add(i);
      }
    }

    return MutashabihatIndex._(
      minWords,
      quran.surahs,
      ayahs,
      {for (var i = 0; i < ayahs.length; i++) ayahs[i].key: i},
      words,
      ranges,
      runs,
      texts,
    );
  }

  /// Colouring for every ayah that repeats anywhere.
  MutashabihatModel coloring() {
    final byAyah = <String, AyahSimilarityModel>{};
    for (var i = 0; i < _ayahs.length; i++) {
      final w = _words[i];
      final full = w.isNotEmpty && _texts[w.join(' ')]!.length > 1;

      final shared = List<bool>.filled(w.length, false);
      for (var j = 0; j + minWords <= w.length; j++) {
        if (_runs[_run(w, j, minWords)]!.length > 1) {
          for (var k = j; k < j + minWords; k++) {
            shared[k] = true;
          }
        }
      }
      final ranges = <(int, int)>[];
      for (var j = 0; j < w.length; j++) {
        if (!shared[j]) continue;
        var end = j;
        while (end + 1 < w.length && shared[end + 1]) {
          end++;
        }
        ranges.add((_wordRanges[i][j].$1, _wordRanges[i][end].$2));
        j = end;
      }

      if (full || ranges.isNotEmpty) {
        byAyah[_ayahs[i].key] = AyahSimilarityModel(
          fullMatch: full,
          partialRanges: ranges,
        );
      }
    }
    return MutashabihatModel(minWords, byAyah);
  }

  /// The other ayahs that repeat [ayahKey]: identical ones, then those sharing
  /// a run of at least [minWords] words, longest shared run first.
  SimilarAyahsModel similarTo(String ayahKey) {
    final i = _indexOfKey[ayahKey];
    if (i == null) {
      return const SimilarAyahsModel(fullMatches: [], partialMatches: []);
    }
    final w = _words[i];
    final twins = {...?_texts[w.join(' ')]}..remove(i);

    final candidates = <int>{};
    for (var j = 0; j + minWords <= w.length; j++) {
      candidates.addAll(_runs[_run(w, j, minWords)]!);
    }
    candidates
      ..remove(i)
      ..removeAll(twins);

    final full = [
      for (final k in twins.toList()..sort()) _similar(k, 0, _words[k].length),
    ];
    final partial = <SimilarAyahModel>[];
    for (final k in candidates.toList()..sort()) {
      final (start, length) = _longestCommonRun(w, _words[k]);
      if (length >= minWords) partial.add(_similar(k, start, length));
    }
    partial.sort((a, b) => b.sharedWords.compareTo(a.sharedWords));
    return SimilarAyahsModel(fullMatches: full, partialMatches: partial);
  }

  SimilarAyahModel _similar(int k, int startWord, int length) {
    final ayah = _ayahs[k];
    final from = _wordRanges[k][startWord].$1;
    final to = _wordRanges[k][startWord + length - 1].$2;
    return SimilarAyahModel(
      ayah: ayah,
      surah: _surahs[ayah.surahNumber - 1],
      sharedText: ayah.text.substring(from, to),
      sharedWords: length,
    );
  }

  /// Start (in [b]) and length of the longest run of words [a] and [b] share.
  static (int, int) _longestCommonRun(List<String> a, List<String> b) {
    var best = 0, bestEnd = 0;
    var prev = List<int>.filled(b.length + 1, 0);
    for (var x = 1; x <= a.length; x++) {
      final cur = List<int>.filled(b.length + 1, 0);
      for (var y = 1; y <= b.length; y++) {
        if (a[x - 1] == b[y - 1]) {
          cur[y] = prev[y - 1] + 1;
          if (cur[y] > best) {
            best = cur[y];
            bestEnd = y;
          }
        }
      }
      prev = cur;
    }
    return (bestEnd - best, best);
  }

  static String _run(List<String> w, int start, int n) =>
      w.sublist(start, start + n).join(' ');

  /// Comparable words of [text] and where each sits in it. Tokens with no
  /// letter (۞, ۩, standalone signs) are not words.
  static (List<String>, List<(int, int)>) _splitWords(String text) {
    final words = <String>[];
    final ranges = <(int, int)>[];
    var start = 0;
    for (var i = 0; i <= text.length; i++) {
      if (i < text.length && text.codeUnitAt(i) != 0x20) continue;
      if (i > start) {
        final word = _normalize(text.substring(start, i));
        if (word.isNotEmpty) {
          words.add(word);
          ranges.add((start, i));
        }
      }
      start = i + 1;
    }
    return (words, ranges);
  }

  static String _normalize(String word) {
    final out = StringBuffer();
    for (final c in word.codeUnits) {
      switch (c) {
        case 0x0671 || 0x0623 || 0x0625 || 0x0622:
          out.writeCharCode(0x0627);
        case 0x0649:
          out.writeCharCode(0x064A);
        case 0x0629:
          out.writeCharCode(0x0647);
        default:
          if (c >= 0x0621 && c <= 0x064A) out.writeCharCode(c);
      }
    }
    return out.toString();
  }
}
