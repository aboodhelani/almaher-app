import 'package:equatable/equatable.dart';

class AyahModel extends Equatable {
  final int surahNumber;
  final int numberInSurah;
  final int page;
  final int juz;
  final int hizbQuarter;
  final bool isSajda;

  /// Uthmani text, without the end-of-ayah marker.
  final String text;

  const AyahModel({
    required this.surahNumber,
    required this.numberInSurah,
    required this.page,
    required this.juz,
    required this.hizbQuarter,
    required this.isSajda,
    required this.text,
  });

  /// Stable `surah:ayah` id — what highlights and search results point at.
  String get key => '$surahNumber:$numberInSurah';

  /// Asset rows are `[surah, ayah, page, juz, hizbQuarter, sajda, text]`.
  factory AyahModel.fromRow(List<dynamic> row) {
    return AyahModel(
      surahNumber: row[0] as int,
      numberInSurah: row[1] as int,
      page: row[2] as int,
      juz: row[3] as int,
      hizbQuarter: row[4] as int,
      isSajda: row[5] == 1,
      text: row[6] as String,
    );
  }

  @override
  List<Object?> get props => [surahNumber, numberInSurah];
}
