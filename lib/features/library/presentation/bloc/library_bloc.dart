import 'package:bloc/bloc.dart';

import '../../../../core/utils/usecases/usecase.dart';
import '../../domain/models/library_models.dart';
import '../../domain/usecases/library_usecases.dart';

part 'library_event.dart';
part 'library_state.dart';

/// Downloadable tafsirs, translations and recitations: what is on the
/// device, what is downloading, and what the reader uses. Lives for the
/// whole app so downloads keep going while the user moves around.
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final GetLibraryCatalogUseCase getCatalogUseCase;
  final GetDownloadedEditionsUseCase getDownloadedEditionsUseCase;
  final DownloadEditionUseCase downloadEditionUseCase;
  final DeleteEditionUseCase deleteEditionUseCase;
  final GetDownloadedSurahsUseCase getDownloadedSurahsUseCase;
  final DownloadSurahUseCase downloadSurahUseCase;
  final DeleteSurahUseCase deleteSurahUseCase;
  final GetLibrarySelectionUseCase getSelectionUseCase;
  final SetLibrarySelectionUseCase setSelectionUseCase;

  LibraryBloc({
    required this.getCatalogUseCase,
    required this.getDownloadedEditionsUseCase,
    required this.downloadEditionUseCase,
    required this.deleteEditionUseCase,
    required this.getDownloadedSurahsUseCase,
    required this.downloadSurahUseCase,
    required this.deleteSurahUseCase,
    required this.getSelectionUseCase,
    required this.setSelectionUseCase,
  }) : super(const LibraryState()) {
    on<LibraryStarted>((e, emit) async {
      final selection = await getSelectionUseCase.call(NoParams());
      final editions = await getDownloadedEditionsUseCase.call(NoParams());
      final surahs = await getDownloadedSurahsUseCase.call(NoParams());
      emit(state.copyWith(
        selection: selection.fold((_) => null, (s) => s),
        editions: editions.fold((_) => null, (l) => l),
        surahs: surahs.fold((_) => null, (m) => m),
      ));
    });

    on<LibraryCatalogRequested>((e, emit) async {
      if (state.catalogLoading || (state.catalog != null && !e.force)) return;
      emit(state.copyWith(catalogLoading: true, catalogError: false));
      final result = await getCatalogUseCase.call(NoParams());
      result.fold(
        (_) => emit(state.copyWith(catalogLoading: false, catalogError: true)),
        (c) => emit(state.copyWith(catalogLoading: false, catalog: c)),
      );
    });

    on<EditionDownloadRequested>((e, emit) async {
      final id = e.edition.identifier;
      if (state.downloadingEditions.contains(id)) return;
      emit(state.copyWith(downloadingEditions: {...state.downloadingEditions, id}));
      final result = await downloadEditionUseCase.call(id);
      final editions = await getDownloadedEditionsUseCase.call(NoParams());
      emit(state.copyWith(
        downloadingEditions: {...state.downloadingEditions}..remove(id),
        editions: editions.fold((_) => null, (l) => l),
        failure: result.fold((f) => LibraryFailure(f.errorMessage), (_) => null),
      ));
    });

    on<EditionDeleted>((e, emit) async {
      await deleteEditionUseCase.call(e.identifier);
      final editions = await getDownloadedEditionsUseCase.call(NoParams());
      final list = editions.fold((_) => state.editions, (l) => l);
      // A deleted edition falls back to the bundled one.
      final sel = state.selection;
      final reset = SelectionParams(
        tafsir: sel.tafsir == e.identifier ? 'ar.muyassar' : null,
        translation: sel.translation == e.identifier ? 'en.sahih' : null,
      );
      final selection = await setSelectionUseCase.call(reset);
      emit(state.copyWith(
        editions: list,
        selection: selection.fold((_) => null, (s) => s),
      ));
    });

    on<SurahDownloadRequested>((e, emit) async {
      final key = surahKey(e.reciter, e.surah);
      if (state.surahProgress.containsKey(key)) return;
      emit(state.copyWith(surahProgress: {...state.surahProgress, key: 0}));
      final result = await downloadSurahUseCase.call(SurahParams(
        e.reciter,
        e.surah,
        onProgress: (p) => add(_SurahProgressed(key, p)),
      ));
      final surahs = await getDownloadedSurahsUseCase.call(NoParams());
      emit(state.copyWith(
        surahProgress: {...state.surahProgress}..remove(key),
        surahs: surahs.fold((_) => null, (m) => m),
        failure: result.fold((f) => LibraryFailure(f.errorMessage), (_) => null),
      ));
    });

    on<_SurahProgressed>((e, emit) {
      if (!state.surahProgress.containsKey(e.key)) return;
      emit(state.copyWith(surahProgress: {...state.surahProgress, e.key: e.progress}));
    });

    on<SurahDeleted>((e, emit) async {
      await deleteSurahUseCase.call(SurahParams(e.reciter, e.surah));
      final surahs = await getDownloadedSurahsUseCase.call(NoParams());
      emit(state.copyWith(surahs: surahs.fold((_) => null, (m) => m)));
    });

    on<LibrarySelectionChanged>((e, emit) async {
      final result = await setSelectionUseCase.call(SelectionParams(
        tafsir: e.tafsir,
        translation: e.translation,
        reciter: e.reciter,
      ));
      result.fold((_) {}, (s) => emit(state.copyWith(selection: s)));
    });
  }
}
