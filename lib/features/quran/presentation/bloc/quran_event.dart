part of 'quran_bloc.dart';

abstract class QuranEvent {
  const QuranEvent();
}

class QuranStarted extends QuranEvent {
  /// Opens this page instead of the last one read.
  final int? page;

  const QuranStarted({this.page});
}

class QuranPageChanged extends QuranEvent {
  final int page;

  const QuranPageChanged(this.page);
}

/// Selects an ayah: from a search result or a long press.
class QuranAyahHighlighted extends QuranEvent {
  final String ayahKey;

  const QuranAyahHighlighted(this.ayahKey);
}

class QuranHighlightCleared extends QuranEvent {
  const QuranHighlightCleared();
}

/// Loads the colouring of repeated ayahs for this minimum of shared words.
class QuranMutashabihatRequested extends QuranEvent {
  final int minWords;

  const QuranMutashabihatRequested(this.minWords);
}
