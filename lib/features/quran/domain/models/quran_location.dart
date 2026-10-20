/// A place to open in the mushaf: a page, optionally with an ayah to highlight.
class QuranLocation {
  final int page;

  /// `surah:ayah` key of the ayah to highlight, if any.
  final String? ayahKey;

  const QuranLocation({required this.page, this.ayahKey});
}
