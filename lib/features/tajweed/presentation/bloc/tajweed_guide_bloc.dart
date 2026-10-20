import 'package:bloc/bloc.dart';

import '../../../../core/utils/usecases/usecase.dart';
import '../../../quran/domain/models/ayah_model.dart';
import '../../../quran/domain/models/surah_model.dart';
import '../../../quran/domain/usecases/quran_usecases.dart';
import '../../domain/models/tajweed_rule.dart';
import '../../domain/models/tajweed_span_model.dart';
import '../../domain/usecases/get_tajweed_usecase.dart';

part 'tajweed_guide_event.dart';
part 'tajweed_guide_state.dart';

/// Finds a real example in the Quran for every rule in the colour guide.
class TajweedGuideBloc extends Bloc<TajweedGuideEvent, TajweedGuideState> {
  final GetQuranUseCase getQuranUseCase;
  final GetTajweedUseCase getTajweedUseCase;

  TajweedGuideBloc({
    required this.getQuranUseCase,
    required this.getTajweedUseCase,
  }) : super(TajweedGuideLoading()) {
    on<TajweedGuideStarted>(_onStarted);
  }

  Future<void> _onStarted(
    TajweedGuideStarted event,
    Emitter<TajweedGuideState> emit,
  ) async {
    emit(TajweedGuideLoading());
    final quranResult = await getQuranUseCase.call(NoParams());
    final tajweedResult = await getTajweedUseCase.call(NoParams());

    final quran = quranResult.fold((_) => null, (q) => q);
    final tajweed = tajweedResult.fold((_) => null, (t) => t);
    if (quran == null || tajweed == null) {
      // The guide still lists the colours, just without examples.
      emit(const TajweedGuideLoaded({}));
      return;
    }

    final examples = <TajweedRule, TajweedExample>{};
    outer:
    for (final page in quran.pages) {
      for (final ayah in page.ayahs) {
        for (final span in tajweed.forAyah(ayah.key)) {
          if (examples.containsKey(span.rule)) continue;
          examples[span.rule] = TajweedExample(
            ayah: ayah,
            surah: quran.surah(ayah.surahNumber),
            span: span,
          );
          if (examples.length == TajweedRule.values.length) break outer;
        }
      }
    }
    emit(TajweedGuideLoaded(examples));
  }
}
