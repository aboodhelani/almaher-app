import 'package:equatable/equatable.dart';

import 'ayah_model.dart';
import 'mushaf_line_model.dart';

class QuranPageModel extends Equatable {
  final int pageNumber;
  final List<AyahModel> ayahs;

  /// The page's lines as printed in the Madani mushaf.
  final List<MushafLineModel> lines;

  const QuranPageModel({
    required this.pageNumber,
    required this.ayahs,
    this.lines = const [],
  });

  int get juz => ayahs.first.juz;

  int get firstSurahNumber => ayahs.first.surahNumber;

  @override
  List<Object?> get props => [pageNumber];
}
