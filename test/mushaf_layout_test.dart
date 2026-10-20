import 'dart:io';

import 'package:almaher/features/quran/data/data_sources/local/quran_local_data_source.dart';
import 'package:almaher/features/quran/domain/models/mushaf_line_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final quran = parseQuranJson((
    File('assets/quran/quran_uthmani.json').readAsStringSync(),
    File('assets/quran/layout_madani.json').readAsStringSync(),
  ));

  String lineText(MushafLineModel line) => switch (line) {
    SurahBannerLine(:final surahNumber) => '[$surahNumber]',
    BasmalaLine() => '[basmala]',
    TextLine(:final segments) => [
      for (final s in segments)
        s.ayah.text.substring(s.charRange.$1, s.charRange.$2) +
            (s.endsAyah ? ' (${s.ayah.numberInSurah})' : ''),
    ].join(' ').trim(),
  };

  test('every page has its printed lines: 15, or 8 on the first two', () {
    for (final page in quran.pages) {
      expect(page.lines, hasLength(page.pageNumber <= 2 ? 8 : 15));
    }
  });

  // Letters only: the text's marks may be ordered differently.
  String letters(String s) =>
      s.replaceAll(RegExp('[\u064B-\u065F\u0670\u06D6-\u06ED\u0640]'), '');

  test('page 528 breaks its lines as the printed mushaf does', () {
    final lines = quran.page(528).lines.map(lineText).map(letters).toList();
    expect(lines[0], endsWith(letters('(46) وَأَنَّ')));
    expect(lines[7], endsWith('(62)'));
    expect(lines[8], '[54]');
    expect(lines[9], '[basmala]');
    expect(lines[14], startsWith(letters('(5) فَتَوَلَّ')));
  });

  test('a surah banner can end a page, its basmala opening the next', () {
    expect(lineText(quran.page(76).lines.last), '[4]');
    expect(lineText(quran.page(77).lines.first), '[basmala]');
  });
}
