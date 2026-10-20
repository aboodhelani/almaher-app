import 'package:dartz/dartz.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/models/library_models.dart';
import '../../domain/repositories/library_repo.dart';
import '../data_sources/local/library_local_data_source.dart';
import '../data_sources/remote/library_remote_data_source.dart';

class LibraryRepoImpl implements LibraryRepo {
  final LibraryRemoteDataSource _remote;
  final LibraryLocalDataSource _local;

  LibraryRepoImpl(this._remote, this._local);

  @override
  Future<Either<Failure, LibraryCatalogModel>> catalog() => _guard(() async {
    final results = await Future.wait([
      _remote.editions(EditionType.tafsir),
      _remote.editions(EditionType.translation),
      _remote.reciters(),
    ]);
    // Bundled editions first, marked as such; the default reciter first.
    List<EditionModel> merge(List<EditionModel> online, EditionType type) => [
      ...bundledEditions.where((e) => e.type == type),
      ...online.where((e) => !bundledEditions.any((b) => b.identifier == e.identifier)),
    ];
    final reciters = results[2] as List<ReciterModel>;
    return LibraryCatalogModel(
      tafsirs: merge(results[0] as List<EditionModel>, EditionType.tafsir),
      translations: merge(results[1] as List<EditionModel>, EditionType.translation),
      reciters: [
        defaultReciter,
        ...reciters.where((r) => r.identifier != defaultReciter.identifier),
      ],
    );
  });

  @override
  Future<Either<Failure, List<EditionModel>>> downloadedEditions() =>
      _guard(() async => _local.downloadedEditions());

  @override
  Future<Either<Failure, void>> downloadEdition(String identifier) =>
      _guard(() async => _local.saveEdition(await _remote.edition(identifier)));

  @override
  Future<Either<Failure, void>> deleteEdition(String identifier) =>
      _guard(() => _local.deleteEdition(identifier));

  @override
  Future<Either<Failure, String>> ayahText(String identifier, int ayahIndex) =>
      _guard(() async => (await _local.editionTexts(identifier))[ayahIndex]);

  @override
  Future<Either<Failure, Map<String, Set<int>>>> downloadedSurahs() =>
      _guard(_local.downloadedSurahs);

  @override
  Future<Either<Failure, void>> downloadSurah(
    String reciter,
    int surah,
    void Function(double progress) onProgress,
  ) => _guard(() async {
    final urls = await _remote.surahAudio(reciter, surah);
    for (var i = 0; i < urls.length; i++) {
      final file = await _local.ayahAudio(reciter, surah, i + 1);
      if (!await file.exists()) {
        // Main source, then the fallbacks.
        ServerException? last;
        for (final url in urls[i]) {
          try {
            await _remote.downloadFile(url, file);
            last = null;
            break;
          } on ServerException catch (e) {
            last = e;
          }
        }
        if (last != null) throw last;
      }
      onProgress((i + 1) / urls.length);
    }
    await _local.markSurahComplete(reciter, surah);
  });

  @override
  Future<Either<Failure, void>> deleteSurah(String reciter, int surah) =>
      _guard(() => _local.deleteSurah(reciter, surah));

  @override
  Future<Either<Failure, List<String>>> surahFiles(
    String reciter,
    int surah,
    int ayahCount,
  ) => _guard(() async {
    if (!await _local.isSurahDownloaded(reciter, surah)) {
      throw const ServerException('not_downloaded');
    }
    return [
      for (var a = 1; a <= ayahCount; a++)
        (await _local.ayahAudio(reciter, surah, a)).path,
    ];
  });

  @override
  LibrarySelectionModel selection() => _local.selection();

  @override
  Future<void> select({String? tafsir, String? translation, String? reciter}) =>
      _local.select(tafsir: tafsir, translation: translation, reciter: reciter);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
