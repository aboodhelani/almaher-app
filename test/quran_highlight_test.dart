import 'package:almaher/core/network/error/failures.dart';
import 'package:almaher/features/quran/domain/models/quran_model.dart';
import 'package:almaher/features/quran/domain/repositories/quran_repo.dart';
import 'package:almaher/features/quran/domain/usecases/quran_usecases.dart';
import 'package:almaher/features/quran/presentation/bloc/quran_bloc.dart';
import 'package:almaher/features/mutashabihat/domain/models/mutashabihat_model.dart';
import 'package:almaher/features/mutashabihat/domain/models/similar_ayahs_model.dart';
import 'package:almaher/features/mutashabihat/domain/repositories/mutashabihat_repo.dart';
import 'package:almaher/features/mutashabihat/domain/usecases/get_mutashabihat_usecase.dart';
import 'package:almaher/features/tajweed/domain/models/tajweed_model.dart';
import 'package:almaher/features/tajweed/domain/repositories/tajweed_repo.dart';
import 'package:almaher/features/tajweed/domain/usecases/get_tajweed_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repo implements QuranRepo {
  @override
  Future<Either<Failure, QuranModel>> getQuran() async =>
      const Right(QuranModel(surahs: [], pages: []));

  @override
  Future<Either<Failure, int>> getLastReadPage() async => const Right(1);

  @override
  Future<Either<Failure, void>> saveLastReadPage(int page) async =>
      const Right(null);
}

class _TajweedRepo implements TajweedRepo {
  @override
  Future<Either<Failure, TajweedModel>> getTajweed() async =>
      const Right(TajweedModel({}));
}

class _MutashabihatRepo implements MutashabihatRepo {
  @override
  Future<Either<Failure, MutashabihatModel>> getColoring(int minWords) async =>
      Right(MutashabihatModel(minWords, const {}));

  @override
  Future<Either<Failure, SimilarAyahsModel>> getSimilarAyahs(
    String ayahKey,
    int minWords,
  ) async =>
      const Right(SimilarAyahsModel(fullMatches: [], partialMatches: []));
}

void main() {
  late QuranBloc bloc;

  setUp(() {
    final repo = _Repo();
    bloc =
        QuranBloc(
          getQuranUseCase: GetQuranUseCase(repo),
          getLastReadPageUseCase: GetLastReadPageUseCase(repo),
          saveLastReadPageUseCase: SaveLastReadPageUseCase(repo),
          getTajweedUseCase: GetTajweedUseCase(_TajweedRepo()),
          getMutashabihatUseCase: GetMutashabihatUseCase(_MutashabihatRepo()),
        )..emit(
          const QuranLoaded(
            quran: QuranModel(surahs: [], pages: []),
            initialPage: 1,
            currentPage: 1,
          ),
        );
  });

  tearDown(() => bloc.close());

  String? highlight() => (bloc.state as QuranLoaded).highlightedAyahKey;

  test('highlight, keep it across a page change, then clear it', () async {
    bloc.add(const QuranAyahHighlighted('2:255'));
    await Future<void>.delayed(Duration.zero);
    expect(highlight(), '2:255');

    bloc.add(const QuranPageChanged(42));
    await Future<void>.delayed(Duration.zero);
    expect(highlight(), '2:255');
    expect((bloc.state as QuranLoaded).currentPage, 42);

    bloc.add(const QuranHighlightCleared());
    await Future<void>.delayed(Duration.zero);
    expect(highlight(), isNull);
  });
}
