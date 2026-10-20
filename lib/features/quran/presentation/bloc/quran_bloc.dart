import 'package:bloc/bloc.dart';

import '../../../../core/utils/usecases/usecase.dart';
import '../../domain/models/quran_model.dart';
import '../../../mutashabihat/domain/usecases/get_mutashabihat_usecase.dart';
import '../../../mutashabihat/domain/models/mutashabihat_model.dart';
import '../../../tajweed/domain/models/tajweed_model.dart';
import '../../../tajweed/domain/usecases/get_tajweed_usecase.dart';
import '../../domain/usecases/quran_usecases.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final GetQuranUseCase getQuranUseCase;
  final GetLastReadPageUseCase getLastReadPageUseCase;
  final SaveLastReadPageUseCase saveLastReadPageUseCase;
  final GetTajweedUseCase getTajweedUseCase;
  final GetMutashabihatUseCase getMutashabihatUseCase;

  int? _requestedMinWords;

  QuranBloc({
    required this.getQuranUseCase,
    required this.getLastReadPageUseCase,
    required this.saveLastReadPageUseCase,
    required this.getTajweedUseCase,
    required this.getMutashabihatUseCase,
  }) : super(QuranLoading()) {
    on<QuranMutashabihatRequested>(_onMutashabihatRequested);
    on<QuranStarted>(_onStarted);
    on<QuranPageChanged>(_onPageChanged);
    on<QuranAyahHighlighted>(_onAyahHighlighted);
    on<QuranHighlightCleared>(_onHighlightCleared);
  }

  Future<void> _onStarted(QuranStarted event, Emitter<QuranState> emit) async {
    emit(QuranLoading());
    final quranResult = await getQuranUseCase.call(NoParams());
    final lastPage =
        event.page ??
        (await getLastReadPageUseCase.call(
          NoParams(),
        )).fold<int>((_) => 1, (page) => page);
    // Without tajweed data the mushaf still shows, just uncoloured.
    final tajweed = (await getTajweedUseCase.call(
      NoParams(),
    )).fold<TajweedModel?>((_) => null, (t) => t);

    quranResult.fold(
      (failure) => emit(QuranError(failure.errorMessage)),
      (quran) => emit(
        QuranLoaded(
          quran: quran,
          initialPage: lastPage.clamp(1, quran.pages.length),
          currentPage: lastPage.clamp(1, quran.pages.length),
          tajweed: tajweed,
        ),
      ),
    );
  }

  Future<void> _onPageChanged(
    QuranPageChanged event,
    Emitter<QuranState> emit,
  ) async {
    final current = state;
    if (current is! QuranLoaded) return;
    emit(current.copyWith(currentPage: event.page));
    await saveLastReadPageUseCase.call(event.page);
  }

  void _onAyahHighlighted(
    QuranAyahHighlighted event,
    Emitter<QuranState> emit,
  ) {
    final current = state;
    if (current is! QuranLoaded) return;
    emit(current.copyWith(highlightedAyahKey: event.ayahKey));
  }

  void _onHighlightCleared(
    QuranHighlightCleared event,
    Emitter<QuranState> emit,
  ) {
    final current = state;
    if (current is! QuranLoaded || current.highlightedAyahKey == null) return;
    emit(current.copyWith(clearHighlight: true));
  }

  /// Loads the similarity colouring for [QuranMutashabihatRequested.minWords];
  /// a result for an older minimum is dropped.
  Future<void> _onMutashabihatRequested(
    QuranMutashabihatRequested event,
    Emitter<QuranState> emit,
  ) async {
    _requestedMinWords = event.minWords;
    final result = await getMutashabihatUseCase.call(event.minWords);
    final current = state;
    if (current is! QuranLoaded || event.minWords != _requestedMinWords) return;
    result.fold((_) {}, (model) => emit(current.copyWith(mutashabihat: model)));
  }
}
