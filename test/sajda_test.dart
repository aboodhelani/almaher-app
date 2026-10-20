import 'dart:convert';
import 'dart:io';

import 'package:almaher/features/quran/domain/models/ayah_model.dart';
import 'package:almaher/features/quran/presentation/widgets/sajda_words.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final rows =
      (jsonDecode(File('assets/quran/quran_uthmani.json').readAsStringSync())
              as Map)['ayahs']
          as List;
  final ayahs = {
    for (final r in rows)
      '${r[0]}:${r[1]}': AyahModel.fromRow(r as List<dynamic>),
  };

  test('each of the 15 sajdas lines over words that speak of it', () {
    final lined = <String, String>{};
    for (final entry in ayahs.entries) {
      final range = sajdaRange(entry.value);
      if (range == null) continue;
      lined[entry.key] = entry.value.text.substring(range.$1, range.$2);
    }
    // Letters only: the text's marks may be ordered differently.
    String letters(String s) =>
        s.replaceAll(RegExp('[\u064B-\u065F\u0670\u06D6-\u06ED\u0640]'), '');
    expect(lined, hasLength(15));
    expect(letters(lined['53:62']!), letters('فَٱسْجُدُوا لِلَّهِ'));
    expect(letters(lined['38:24']!), letters('وَخَرَّ رَاكِعًا وَأَنَابَ'));
    // The line can sit in an earlier ayah than the ۩.
    expect(letters(lined['16:49']!), letters('وَلِلَّهِ يَسْجُدُ'));
    for (final text in lined.values) {
      expect(text.trim(), text);
      expect(text, isNotEmpty);
    }
  });
}
