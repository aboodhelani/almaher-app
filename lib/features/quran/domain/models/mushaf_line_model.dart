import 'ayah_model.dart';

/// One of the 15 lines of a Madani mushaf page (8 on the first two pages).
sealed class MushafLineModel {
  const MushafLineModel();
}

/// The banner that opens a surah.
class SurahBannerLine extends MushafLineModel {
  final int surahNumber;

  const SurahBannerLine(this.surahNumber);
}

/// The basmala on its own line.
class BasmalaLine extends MushafLineModel {
  const BasmalaLine();
}

/// A line of text: pieces of one or more ayahs, as printed.
class TextLine extends MushafLineModel {
  final List<LineSegmentModel> segments;

  const TextLine(this.segments);
}

/// Words [fromWord, toWord) of [ayah] — indexes into its text split on
/// spaces — and whether the ayah ends on this line (its number follows).
class LineSegmentModel {
  final AyahModel ayah;
  final int fromWord;
  final int toWord;
  final bool endsAyah;

  const LineSegmentModel({
    required this.ayah,
    required this.fromWord,
    required this.toWord,
    required this.endsAyah,
  });

  /// The segment's characters [start, end) in the ayah's text.
  (int, int) get charRange {
    final words = ayah.text.split(' ');
    var start = 0;
    for (var i = 0; i < fromWord; i++) {
      start += words[i].length + 1;
    }
    // Just the ayah's number (its words ended on the line before).
    if (fromWord >= toWord) return (ayah.text.length, ayah.text.length);
    var end = start;
    for (var i = fromWord; i < toWord; i++) {
      end += words[i].length + (i > fromWord ? 1 : 0);
    }
    return (start, end);
  }
}
