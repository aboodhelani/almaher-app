part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

/// Loads the surahs the search can be filtered by.
class SearchStarted extends SearchEvent {
  const SearchStarted();
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);
}

/// Limits the search to [surah]; `null` searches the whole Quran.
class SearchSurahFilterChanged extends SearchEvent {
  final SurahModel? surah;

  const SearchSurahFilterChanged(this.surah);
}
