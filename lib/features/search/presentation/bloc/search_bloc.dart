import 'package:bloc/bloc.dart';

import '../../../../core/utils/usecases/usecase.dart';
import '../../../quran/domain/models/surah_model.dart';
import '../../domain/models/search_results_model.dart';
import '../../domain/usecases/search_usecases.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchQuranUseCase searchQuranUseCase;
  final GetSurahsUseCase getSurahsUseCase;

  String _query = '';
  SurahModel? _filter;
  List<SurahModel> _surahs = const [];

  /// Bumped on every search; results of older searches are dropped.
  int _generation = 0;

  SearchBloc({required this.searchQuranUseCase, required this.getSurahsUseCase})
    : super(const SearchInitial()) {
    on<SearchStarted>(_onStarted);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchSurahFilterChanged>(_onFilterChanged);
  }

  Future<void> _onStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    final result = await getSurahsUseCase.call(NoParams());
    result.fold((_) {}, (surahs) => _surahs = surahs);
    if (state is SearchInitial) emit(_initial());
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    _query = event.query.trim();
    await _search(emit);
  }

  Future<void> _onFilterChanged(
    SearchSurahFilterChanged event,
    Emitter<SearchState> emit,
  ) async {
    _filter = event.surah;
    await _search(emit);
  }

  Future<void> _search(Emitter<SearchState> emit) async {
    final generation = ++_generation;
    if (_query.isEmpty) {
      emit(_initial());
      return;
    }
    // The first search also builds the index, which takes a moment.
    if (state is! SearchLoaded) {
      emit(SearchLoading(surahs: _surahs, surahFilter: _filter));
    }

    final result = await searchQuranUseCase.call(
      SearchParams(query: _query, surahNumber: _filter?.number),
    );
    if (generation != _generation) return;

    result.fold(
      (failure) => emit(
        SearchError(
          failure.errorMessage,
          surahs: _surahs,
          surahFilter: _filter,
        ),
      ),
      (results) =>
          emit(SearchLoaded(results, surahs: _surahs, surahFilter: _filter)),
    );
  }

  SearchInitial _initial() =>
      SearchInitial(surahs: _surahs, surahFilter: _filter);
}
