import 'dart:io';

import 'package:almaher/features/quran/data/data_sources/local/quran_local_data_source.dart';
import 'package:almaher/features/search/data/data_sources/local/quran_search_index.dart';
import 'package:almaher/features/search/domain/models/search_results_model.dart';
import 'package:almaher/features/search/presentation/utils/ayah_snippet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final quran = parseQuranJson((
    File('assets/quran/quran_uthmani.json').readAsStringSync(),
    null,
  ));
  final index = QuranSearchIndex.build(quran);

  List<String> keys(List<AyahSearchResult> results) =>
      results.map((r) => r.ayah.key).toList();

  group('surahs', () {
    test('by name, with or without سورة / ال / tashkeel', () {
      for (final q in ['البقرة', 'سورة البقرة', 'بقره', 'البَقَرَة']) {
        expect(
          index.search(q).surahs.map((s) => s.number),
          contains(2),
          reason: q,
        );
      }
      expect(index.search('الفاتحة').surahs.map((s) => s.number), [1]);
    });
  });

  group('partial match (no tashkeel)', () {
    test('finds Uthmani spellings typed the modern way', () {
      expect(
        keys(index.search('الحمد لله رب العالمين').partialMatches),
        contains('1:2'),
      ); // ٱلْعَٰلَمِينَ — dagger alef typed as ا
      expect(
        keys(index.search('ذلك الكتاب').partialMatches),
        contains('2:2'),
      ); // ذَٰلِكَ — dagger alef skipped
      expect(
        keys(index.search('يقيمون الصلاة').partialMatches),
        contains('2:3'),
      ); // ٱلصَّلَوٰةَ — وٰ read as ا
      expect(
        keys(index.search('في قلوبهم مرض').partialMatches),
        contains('2:10'),
      ); // فِى — ى folded to ي
    });

    test('spaces are ignored: الحمدلله finds الحمد لله', () {
      for (final q in ['الحمدلله', 'الحمد لله', 'الحمد  لله ']) {
        expect(keys(index.search(q).partialMatches).first, '1:2', reason: q);
        expect(keys(index.search(q, surahNumber: 1).partialMatches), [
          '1:2',
        ], reason: q);
      }
      expect(
        keys(index.search('الْحَمْدُلِلَّهِ').fullMatches),
        contains('1:2'),
      );
    });

    test('a query without tashkeel never yields full matches', () {
      final results = index.search('الحمد لله');
      expect(results.queryHasTashkeel, isFalse);
      expect(results.fullMatches, isEmpty);
      expect(keys(results.partialMatches), contains('1:2'));
    });

    test('one letter is too short to search', () {
      expect(index.search('ب').isEmpty, isTrue);
    });
  });

  group('full match (with tashkeel)', () {
    test('matching tashkeel is a full match, in either mark order', () {
      for (final q in [
        'ٱلْحَمْدُ لِلَّهِ', // copied from the mushaf
        'الْحَمْدُ لِلَّهِ', // plain alef instead of ٱ
        'الْحَمْدُ لِلَّهِ', // shadda typed after fatha
      ]) {
        final results = index.search(q);
        expect(keys(results.fullMatches), contains('1:2'), reason: q);
        expect(keys(results.partialMatches), isNot(contains('1:2')), reason: q);
      }
    });

    test('different tashkeel falls back to a partial match', () {
      final results = index.search('الْحَمَدُ');
      expect(keys(results.fullMatches), isNot(contains('1:2')));
      expect(keys(results.partialMatches), contains('1:2'));
    });
  });

  group('surah filter', () {
    test('a number picks that ayah, in any digits', () {
      for (final q in ['255', '٢٥٥', '۲۵۵']) {
        final results = index.search(q, surahNumber: 2);
        expect(results.ayahByNumber?.ayah.key, '2:255', reason: q);
      }
    });

    test('a number past the end of the surah finds nothing', () {
      expect(index.search('8', surahNumber: 1).isEmpty, isTrue);
    });

    test('a number without a filter is not an ayah lookup', () {
      expect(index.search('255').ayahByNumber, isNull);
    });

    test('text is searched only inside the surah, with no surah list', () {
      final results = index.search('الرحمن', surahNumber: 55);
      final all = [...results.fullMatches, ...results.partialMatches];
      expect(all, isNotEmpty);
      expect(all.every((r) => r.ayah.surahNumber == 55), isTrue);
      expect(results.surahs, isEmpty);
    });

    test('the last surah is searchable too', () {
      final results = index.search('الناس', surahNumber: 114);
      expect(results.partialMatches.map((r) => r.ayah.key), contains('114:1'));
    });
  });

  group('ayah snippet', () {
    test('long ayah: first five words ..... last word', () {
      final ayah = quran.page(3).ayahs.firstWhere((a) => a.key == '2:6');
      final words = ayahSnippet(ayah.text).split(' ');
      expect(words.length, 7);
      expect(words[5], '.....');
    });

    test('short ayah is shown whole', () {
      expect(
        ayahSnippet('ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ'),
        'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ',
      );
    });

    test('signs like ۞ are not counted as words', () {
      expect(ayahSnippet('۞ وَإِذَا صُرِفَتْ'), 'وَإِذَا صُرِفَتْ');
    });
  });

  test('a common word across the whole Quran is fast enough', () {
    final watch = Stopwatch()..start();
    final results = index.search('الله');
    watch.stop();
    expect(results.partialMatches.length, greaterThan(1000));
    expect(watch.elapsedMilliseconds, lessThan(500));
  });
}
