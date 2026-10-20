import 'package:dartz/dartz.dart';

import '../../../../core/network/error/failures.dart';
import '../../../../core/utils/usecases/usecase.dart';
import '../models/library_models.dart';
import '../repositories/library_repo.dart';

class GetLibraryCatalogUseCase extends UseCase<LibraryCatalogModel, NoParams> {
  final LibraryRepo repository;

  GetLibraryCatalogUseCase(this.repository);

  @override
  Future<Either<Failure, LibraryCatalogModel>> call(NoParams params) =>
      repository.catalog();
}

class GetDownloadedEditionsUseCase extends UseCase<List<EditionModel>, NoParams> {
  final LibraryRepo repository;

  GetDownloadedEditionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<EditionModel>>> call(NoParams params) =>
      repository.downloadedEditions();
}

class DownloadEditionUseCase extends UseCase<void, String> {
  final LibraryRepo repository;

  DownloadEditionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) =>
      repository.downloadEdition(params);
}

class DeleteEditionUseCase extends UseCase<void, String> {
  final LibraryRepo repository;

  DeleteEditionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) =>
      repository.deleteEdition(params);
}

class AyahTextParams {
  final String edition;

  /// 0-based position of the ayah in the Quran (see globalAyahIndex).
  final int ayahIndex;

  const AyahTextParams(this.edition, this.ayahIndex);
}

class GetAyahTextUseCase extends UseCase<String, AyahTextParams> {
  final LibraryRepo repository;

  GetAyahTextUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(AyahTextParams params) =>
      repository.ayahText(params.edition, params.ayahIndex);
}

class GetDownloadedSurahsUseCase extends UseCase<Map<String, Set<int>>, NoParams> {
  final LibraryRepo repository;

  GetDownloadedSurahsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, Set<int>>>> call(NoParams params) =>
      repository.downloadedSurahs();
}

class SurahParams {
  final String reciter;
  final int surah;
  final void Function(double progress)? onProgress;

  const SurahParams(this.reciter, this.surah, {this.onProgress});
}

class DownloadSurahUseCase extends UseCase<void, SurahParams> {
  final LibraryRepo repository;

  DownloadSurahUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SurahParams params) => repository
      .downloadSurah(params.reciter, params.surah, params.onProgress ?? (_) {});
}

class DeleteSurahUseCase extends UseCase<void, SurahParams> {
  final LibraryRepo repository;

  DeleteSurahUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SurahParams params) =>
      repository.deleteSurah(params.reciter, params.surah);
}

class SurahFilesParams {
  final String reciter;
  final int surah;
  final int ayahCount;

  const SurahFilesParams(this.reciter, this.surah, this.ayahCount);
}

class GetSurahFilesUseCase extends UseCase<List<String>, SurahFilesParams> {
  final LibraryRepo repository;

  GetSurahFilesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(SurahFilesParams params) =>
      repository.surahFiles(params.reciter, params.surah, params.ayahCount);
}

class GetLibrarySelectionUseCase extends UseCase<LibrarySelectionModel, NoParams> {
  final LibraryRepo repository;

  GetLibrarySelectionUseCase(this.repository);

  @override
  Future<Either<Failure, LibrarySelectionModel>> call(NoParams params) async =>
      Right(repository.selection());
}

class SelectionParams {
  final String? tafsir;
  final String? translation;
  final String? reciter;

  const SelectionParams({this.tafsir, this.translation, this.reciter});
}

class SetLibrarySelectionUseCase extends UseCase<LibrarySelectionModel, SelectionParams> {
  final LibraryRepo repository;

  SetLibrarySelectionUseCase(this.repository);

  @override
  Future<Either<Failure, LibrarySelectionModel>> call(SelectionParams params) async {
    await repository.select(
      tafsir: params.tafsir,
      translation: params.translation,
      reciter: params.reciter,
    );
    return Right(repository.selection());
  }
}
