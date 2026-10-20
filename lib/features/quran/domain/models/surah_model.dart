import 'package:equatable/equatable.dart';

enum RevelationType { meccan, medinan }

class SurahModel extends Equatable {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final RevelationType revelationType;
  final int ayahCount;
  final int startPage;

  const SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.revelationType,
    required this.ayahCount,
    required this.startPage,
  });

  /// Every surah opens with the basmala except At-Tawbah (9). In Al-Fatiha (1)
  /// the basmala is ayah 1 itself, so it is not drawn as a separate line.
  bool get hasStandaloneBasmala => number != 1 && number != 9;

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['n'] as int,
      nameArabic: json['ar'] as String,
      nameEnglish: json['en'] as String,
      revelationType: json['t'] == 'md'
          ? RevelationType.medinan
          : RevelationType.meccan,
      ayahCount: json['c'] as int,
      startPage: json['p'] as int,
    );
  }

  @override
  List<Object?> get props => [number];
}
