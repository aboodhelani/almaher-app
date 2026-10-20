import 'dart:io';

import 'package:almaher/core/network/error/failures.dart';
import 'package:almaher/core/styles/app_theme.dart';
import 'package:almaher/core/translations/l10n.dart';
import 'package:almaher/core/utils/app_notifier.dart';
import 'package:almaher/shared/data/data_sources/app_shared_prefs.dart';
import 'package:almaher/features/quran/data/data_sources/local/quran_local_data_source.dart';
import 'package:almaher/features/quran/domain/models/quran_location.dart';
import 'package:almaher/features/search/data/data_sources/local/quran_search_index.dart';
import 'package:almaher/features/search/domain/models/search_results_model.dart';
import 'package:almaher/features/search/domain/repositories/search_repo.dart';
import 'package:almaher/features/quran/domain/models/surah_model.dart';
import 'package:almaher/features/search/domain/usecases/search_usecases.dart';
import 'package:almaher/features/search/presentation/bloc/search_bloc.dart';
import 'package:almaher/features/search/presentation/pages/search_page.dart';
import 'package:almaher/features/search/presentation/widgets/ayah_result_tile.dart';
import 'package:almaher/features/search/presentation/widgets/surah_result_tile.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

class _IndexRepo implements SearchRepo {
  final QuranSearchIndex index;
  final List<SurahModel> surahs;

  _IndexRepo(this.index, this.surahs);

  @override
  Future<Either<Failure, SearchResultsModel>> search(
    String query, {
    int? surahNumber,
  }) async => Right(index.search(query, surahNumber: surahNumber));

  @override
  Future<Either<Failure, List<SurahModel>>> getSurahs() async => Right(surahs);
}

void main() {
  final quran = parseQuranJson((
    File('assets/quran/quran_uthmani.json').readAsStringSync(),
    null,
  ));
  final index = QuranSearchIndex.build(quran);
  final repo = _IndexRepo(index, quran.surahs);

  /// Opens the search page; the returned function gives what it popped with.
  Future<QuranLocation? Function()> openSearch(WidgetTester tester) async {
    QuranLocation? popped;
    var done = false;
    SharedPreferences.setMockInitialValues({});
    final notifier = AppNotifier(
      AppSharedPrefs(await SharedPreferences.getInstance()),
    );
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: notifier,
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => MaterialApp(
            theme: appTheme,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  popped = await Navigator.push<QuranLocation>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => SearchBloc(
                          searchQuranUseCase: SearchQuranUseCase(repo),
                          getSurahsUseCase: GetSurahsUseCase(repo),
                        )..add(const SearchStarted()),
                        child: const SearchPage(),
                      ),
                    ),
                  );
                  done = true;
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return () => done ? popped : null;
  }

  Future<void> search(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pump(const Duration(milliseconds: 300)); // debounce
    await tester.pumpAndSettle();
  }

  testWidgets('surahs come first, then partial matches', (tester) async {
    await openSearch(tester);

    await search(tester, 'الكهف'); // surah 18, and 18:9 أَصْحَٰبَ ٱلْكَهْفِ

    final surahTop = tester.getTopLeft(find.byType(SurahResultTile).first).dy;
    final ayahTop = tester.getTopLeft(find.byType(AyahResultTile).first).dy;
    expect(find.text('السور'), findsOneWidget);
    expect(find.textContaining('مطابقة جزئية'), findsOneWidget);
    expect(find.textContaining('مطابقة تامة'), findsNothing);
    expect(surahTop, lessThan(ayahTop));
  });

  testWidgets('tashkeel shows full matches above partial ones', (tester) async {
    await openSearch(tester);

    await search(tester, 'رَبِّ'); // full: رَبِّ — partial: رَبُّ, رَبَّ

    // Full matches open the list; partial ones follow below them.
    expect(find.textContaining('مطابقة تامة'), findsOneWidget);
    expect(find.text('السور'), findsNothing);
    final results =
        (tester.state(find.byType(SearchPage)).context.read<SearchBloc>().state
                as SearchLoaded)
            .results;
    expect(results.fullMatches, isNotEmpty);
    expect(results.partialMatches, isNotEmpty);
  });

  testWidgets('tapping an ayah pops its page and ayah key', (tester) async {
    final result = await openSearch(tester);

    await search(tester, 'الْحَمْدُ لِلَّهِ رَبِّ');
    await tester.tap(find.byType(AyahResultTile).first);
    await tester.pumpAndSettle();

    final location = result();
    expect(location?.page, 1);
    expect(location?.ayahKey, '1:2');
  });

  testWidgets('tapping a surah pops its first page without an ayah', (
    tester,
  ) async {
    final result = await openSearch(tester);

    await search(tester, 'سورة يس');
    await tester.tap(find.byType(SurahResultTile).first);
    await tester.pumpAndSettle();

    final location = result();
    expect(location?.page, 440);
    expect(location?.ayahKey, isNull);
  });

  testWidgets('filter by surah, then go to an ayah by its number', (
    tester,
  ) async {
    final result = await openSearch(tester);

    expect(find.text('كل السور'), findsOneWidget);
    await tester.tap(find.text('كل السور'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('البَقَرَةِ'));
    await tester.pumpAndSettle();
    expect(find.text('سورة البَقَرَةِ'), findsOneWidget); // the chip

    await search(tester, '٢٥٥');
    expect(find.text('الآية'), findsOneWidget);
    await tester.tap(find.byType(AyahResultTile));
    await tester.pumpAndSettle();

    final location = result();
    expect(location?.ayahKey, '2:255');
    expect(location?.page, 42);
  });
}
