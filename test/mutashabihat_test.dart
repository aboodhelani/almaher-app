import 'dart:io';

import 'package:almaher/features/mutashabihat/data/data_sources/local/mutashabihat_index.dart';
import 'package:almaher/features/quran/data/data_sources/local/quran_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final quran = parseQuranJson((
    File('assets/quran/quran_uthmani.json').readAsStringSync(),
    null,
  ));
  final index2 = MutashabihatIndex.build((quran, 2));
  final coloring2 = index2.coloring();

  test('identical ayahs are full matches, both ways', () {
    // فَبِأَىِّ ءَالَآءِ رَبِّكُمَا تُكَذِّبَانِ — repeated through Ar-Rahman.
    expect(coloring2.forAyah('55:13')!.fullMatch, isTrue);
    final similar = index2.similarTo('55:13');
    final keys = similar.fullMatches.map((s) => s.ayah.key).toList();
    expect(keys, contains('55:16'));
    expect(keys, isNot(contains('55:13')));
    expect(keys.length, 30); // 31 occurrences in all
  });

  test('a shared phrase is a partial match, longest first', () {
    // 2:5 and 31:5 share أُو۟لَٰٓئِكَ عَلَىٰ هُدًۭى مِّن رَّبِّهِمْ ۖ وَأُو۟لَٰٓئِكَ هُمُ ٱلْمُفْلِحُونَ
    final similar = index2.similarTo('2:5');
    expect(similar.fullMatches.map((s) => s.ayah.key), contains('31:5'));

    final partial = index2.similarTo('2:2').partialMatches;
    expect(partial, isNotEmpty);
    for (var i = 1; i < partial.length; i++) {
      expect(partial[i - 1].sharedWords >= partial[i].sharedWords, isTrue);
    }
    expect(partial.every((p) => p.sharedWords >= 2), isTrue);
  });

  test('partial ranges cover whole words inside the ayah', () {
    for (final page in quran.pages.take(50)) {
      for (final ayah in page.ayahs) {
        final s = coloring2.forAyah(ayah.key);
        if (s == null) continue;
        for (final (start, end) in s.partialRanges) {
          expect(start, lessThan(end));
          expect(end, lessThanOrEqualTo(ayah.text.length));
          expect(start == 0 || ayah.text[start - 1] == ' ', isTrue);
        }
      }
    }
  });

  test('a higher minimum colours less', () {
    int coloured(int n) {
      final c = MutashabihatIndex.build((quran, n)).coloring();
      var count = 0;
      for (final page in quran.pages) {
        for (final a in page.ayahs) {
          final s = c.forAyah(a.key);
          if (s != null && (s.fullMatch || s.partialRanges.isNotEmpty)) count++;
        }
      }
      return count;
    }

    expect(coloured(2), greaterThan(coloured(4)));
  });

  test('building the index and colouring is quick', () {
    final watch = Stopwatch()..start();
    MutashabihatIndex.build((quran, 2)).coloring();
    expect(watch.elapsedMilliseconds, lessThan(3000));
  });
}
