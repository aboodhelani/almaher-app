import 'quran_page_model.dart';
import 'surah_model.dart';

class QuranModel {
  final List<SurahModel> surahs;

  /// Index 0 is page 1.
  final List<QuranPageModel> pages;

  const QuranModel({required this.surahs, required this.pages});

  SurahModel surah(int number) => surahs[number - 1];

  QuranPageModel page(int number) => pages[number - 1];
}
