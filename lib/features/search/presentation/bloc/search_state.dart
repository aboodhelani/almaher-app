part of 'search_bloc.dart';

abstract class SearchState {
  /// For the surah filter picker.
  final List<SurahModel> surahs;

  /// The surah the search is limited to, if any.
  final SurahModel? surahFilter;

  const SearchState({this.surahs = const [], this.surahFilter});
}

class SearchInitial extends SearchState {
  const SearchInitial({super.surahs, super.surahFilter});
}

class SearchLoading extends SearchState {
  const SearchLoading({super.surahs, super.surahFilter});
}

class SearchLoaded extends SearchState {
  final SearchResultsModel results;

  const SearchLoaded(this.results, {super.surahs, super.surahFilter});
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message, {super.surahs, super.surahFilter});
}
