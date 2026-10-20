import '../../../quran/domain/models/ayah_model.dart';
import '../../../quran/domain/models/surah_model.dart';

class SimilarAyahModel {
  final AyahModel ayah;
  final SurahModel surah;

  /// The words this ayah shares with the one asked about, as written here.
  final String sharedText;
  final int sharedWords;

  const SimilarAyahModel({
    required this.ayah,
    required this.surah,
    required this.sharedText,
    required this.sharedWords,
  });
}

/// The other places an ayah repeats, fully or in part.
class SimilarAyahsModel {
  final List<SimilarAyahModel> fullMatches;

  /// Longest shared phrase first.
  final List<SimilarAyahModel> partialMatches;

  const SimilarAyahsModel({
    required this.fullMatches,
    required this.partialMatches,
  });

  bool get isEmpty => fullMatches.isEmpty && partialMatches.isEmpty;
}
