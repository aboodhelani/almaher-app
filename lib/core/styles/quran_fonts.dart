import '../utils/arabic_numbers.dart';

/// The fonts the mushaf can be set in. Each draws the ayah-number ornament
/// its own way.
enum QuranFont {
  /// The King Fahd Complex Hafs font: the printed Madani mushaf's look.
  hafs('UthmanicHafs', 'hafs'),
  amiri('AmiriQuran', 'amiri'),
  noto('NotoNaskhArabic', 'noto');

  final String family;

  /// Stored in preferences.
  final String id;

  const QuranFont(this.family, this.id);

  static QuranFont fromId(String? id) =>
      values.firstWhere((f) => f.id == id, orElse: () => hafs);

  /// The end-of-ayah ornament with [number] inside: the Hafs font draws it
  /// from the digits alone; the others from U+06DD followed by the digits.
  String ayahMarker(int number) => this == hafs
      ? number.toArabicDigits
      : '۝${number.toArabicDigits}';

  /// [text] in the encoding this font expects. The Hafs font follows the
  /// King Fahd Complex's text, which writes a few marks differently from
  /// the app's (Tanzil) text: sukun as U+06E1, the round zero as U+0652, and
  /// two rare small marks. One character for one, so positions in the text
  /// (tajweed, highlights, the sajda line) still hold.
  String prepare(String text) {
    if (this != hafs) return text;
    final out = StringBuffer();
    for (final unit in text.codeUnits) {
      out.writeCharCode(switch (unit) {
        0x0652 => 0x06E1, // sukun
        0x06DF => 0x0652, // round zero over a silent letter
        0x06EB => 0x06EC, // the rounded high stop (12:11)
        0x06E3 => 0x06DC, // small seen (52:37)
        _ => unit,
      });
    }
    return out.toString();
  }

  /// How far a surah name with its vowel marks reaches above and below the
  /// baseline, in ems (measured on all the surah names), to centre it by its
  /// ink rather than its line box.
  (double, double) get inkExtent => switch (this) {
    hafs => (0.86, 0.40),
    amiri => (1.14, 0.55),
    noto => (0.90, 0.38),
  };

  /// Font size as a share of a mushaf line's height, before the widest line
  /// is fitted to the page width.
  double get lineFill => switch (this) {
    hafs => 0.62,
    amiri => 0.54,
    noto => 0.56,
  };
}
