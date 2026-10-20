import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bundled Quran text is complete', () {
    final json =
        jsonDecode(File('assets/quran/quran_uthmani.json').readAsStringSync())
            as Map<String, dynamic>;
    final surahs = json['surahs'] as List;
    final ayahs = json['ayahs'] as List;

    expect(surahs.length, 114);
    expect(ayahs.length, 6236);
    expect(surahs.where((s) => s['t'] == 'md').length, 28);
    expect(ayahs.map((a) => a[2] as int).toSet().length, 604);
  });
}
