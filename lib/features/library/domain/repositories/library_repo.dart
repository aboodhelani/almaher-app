import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../models/library_models.dart';

abstract class LibraryRepo {
  /// Tafsirs, translations and reciters available to download.
  Future<Either<Failure, LibraryCatalogModel>> catalog();

  /// Editions on this device (bundled ones first).
  Future<Either<Failure, List<EditionModel>>> downloadedEditions();

  Future<Either<Failure, void>> downloadEdition(String identifier);

  Future<Either<Failure, void>> deleteEdition(String identifier);

  /// The edition's text for one ayah (0-based position in the Quran).
  Future<Either<Failure, String>> ayahText(String identifier, int ayahIndex);

  /// reciter → surahs downloaded on this device.
  Future<Either<Failure, Map<String, Set<int>>>> downloadedSurahs();

  /// Downloads a surah's recitation, reporting progress from 0 to 1.
  Future<Either<Failure, void>> downloadSurah(
    String reciter,
    int surah,
    void Function(double progress) onProgress,
  );

  Future<Either<Failure, void>> deleteSurah(String reciter, int surah);

  /// Local files of a downloaded surah's ayahs, in order.
  Future<Either<Failure, List<String>>> surahFiles(String reciter, int surah, int ayahCount);

  LibrarySelectionModel selection();

  Future<void> select({String? tafsir, String? translation, String? reciter});
}
