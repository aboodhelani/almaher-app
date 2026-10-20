/// Which parts of an ayah repeat elsewhere in the Quran.
class AyahSimilarityModel {
  /// The whole ayah appears, word for word, as another ayah.
  final bool fullMatch;

  /// `[start, end)` character ranges shared with at least one other ayah
  /// (runs of at least the minimum number of words).
  final List<(int, int)> partialRanges;

  const AyahSimilarityModel({
    required this.fullMatch,
    required this.partialRanges,
  });
}

/// Similarity colouring for every ayah, keyed by `surah:ayah`.
class MutashabihatModel {
  /// Partial matches must share at least this many consecutive words.
  final int minWords;
  final Map<String, AyahSimilarityModel> _byAyah;

  const MutashabihatModel(this.minWords, this._byAyah);

  AyahSimilarityModel? forAyah(String ayahKey) => _byAyah[ayahKey];
}
