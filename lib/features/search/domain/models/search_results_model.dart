import '../../../quran/domain/models/ayah_model.dart';
import '../../../quran/domain/models/surah_model.dart';

class AyahSearchResult {
  final AyahModel ayah;
  final SurahModel surah;

  const AyahSearchResult({required this.ayah, required this.surah});
}

/// Results in display order: the ayah picked by number, surahs, then full
/// matches, then partial ones.
class SearchResultsModel {
  final String query;

  /// Full matches only exist when the query was typed with tashkeel.
  final bool queryHasTashkeel;

  /// With a surah filter, a query that is a number picks that ayah.
  final AyahSearchResult? ayahByNumber;
  final List<SurahModel> surahs;

  /// Letters and tashkeel both match.
  final List<AyahSearchResult> fullMatches;

  /// Letters match, ignoring tashkeel (and not already a full match).
  final List<AyahSearchResult> partialMatches;

  const SearchResultsModel({
    required this.query,
    required this.queryHasTashkeel,
    this.ayahByNumber,
    required this.surahs,
    required this.fullMatches,
    required this.partialMatches,
  });

  const SearchResultsModel.empty(this.query)
    : queryHasTashkeel = false,
      ayahByNumber = null,
      surahs = const [],
      fullMatches = const [],
      partialMatches = const [];

  bool get isEmpty =>
      ayahByNumber == null &&
      surahs.isEmpty &&
      fullMatches.isEmpty &&
      partialMatches.isEmpty;
}
