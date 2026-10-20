import 'dart:io';

import 'package:almaher/core/styles/tajweed_palette.dart';
import 'package:almaher/features/quran/data/data_sources/local/quran_local_data_source.dart';
import 'package:almaher/features/quran/domain/models/ayah_model.dart';
import 'package:almaher/features/tajweed/data/data_sources/local/tajweed_local_data_source.dart';
import 'package:almaher/features/tajweed/domain/models/tajweed_rule.dart';
import 'package:almaher/features/tajweed/domain/models/tajweed_span_model.dart';
import 'package:almaher/features/tajweed/presentation/widgets/tajweed_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final quran = parseQuranJson((
    File('assets/quran/quran_uthmani.json').readAsStringSync(),
    null,
  ));
  final ayahs = [for (final p in quran.pages) ...p.ayahs];
  final tajweed = parseTajweedJson((
    File('assets/quran/tajweed.json').readAsStringSync(),
    [for (final a in ayahs) a.key],
  ));
  AyahModel ayah(String key) => ayahs.firstWhere((a) => a.key == key);

  List<(TajweedRule, String)> rulesOf(String key) {
    final text = ayah(key).text;
    return [
      for (final s in tajweed.forAyah(key))
        (s.rule, text.substring(s.start, s.end)),
    ];
  }

  test('every rule has a colour in both themes and appears in the Quran', () {
    final seen = <TajweedRule>{};
    for (final a in ayahs) {
      for (final s in tajweed.forAyah(a.key)) {
        seen.add(s.rule);
        expect(s.start, lessThan(s.end));
        expect(s.end, lessThanOrEqualTo(a.text.length));
      }
    }
    expect(seen, TajweedRule.values.toSet());
    for (final r in TajweedRule.values) {
      TajweedPalette.of(r, Brightness.light);
      TajweedPalette.of(r, Brightness.dark);
    }
  });

  test('spans land on the right letters', () {
    // ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ
    expect(rulesOf('1:2'), [
      (TajweedRule.hamzatWasl, 'ٱ'),
      (TajweedRule.maddNatural, 'ٰ'),
      (TajweedRule.maddPermissible, 'ِي'),
    ]);
    // الٓمٓ — two necessary madds
    expect(rulesOf('2:1'), [
      (TajweedRule.maddNecessary, 'لٓ'),
      (TajweedRule.maddNecessary, 'مٓ'),
    ]);
    // هُدًۭى لِّلْمُتَّقِينَ — tanween into lam: idgham without ghunna
    expect(
      rulesOf('2:2').map((r) => r.$1),
      contains(TajweedRule.idghamWithoutGhunna),
    );
  });

  test('nested spans: the inner rule wins where they overlap', () {
    const base = TextStyle(color: Colors.black);
    final spans = tajweedTextSpans(
      'abcd',
      const [
        TajweedSpanModel(start: 0, end: 4, rule: TajweedRule.maddObligatory),
        TajweedSpanModel(start: 2, end: 3, rule: TajweedRule.silent),
      ],
      base,
      Brightness.light,
    );
    expect(spans.map((s) => s.text), ['ab', 'c', 'd']);
    expect(
      spans[1].style!.color,
      TajweedPalette.of(TajweedRule.silent, Brightness.light),
    );
    expect(
      spans[2].style!.color,
      TajweedPalette.of(TajweedRule.maddObligatory, Brightness.light),
    );
  });

  test('uncoloured text keeps the base style, as one piece', () {
    const base = TextStyle(color: Colors.black);
    final spans = tajweedTextSpans('بسم', const [], base, Brightness.light);
    expect(spans.single.text, 'بسم');
    expect(spans.single.style, base);
  });
}
