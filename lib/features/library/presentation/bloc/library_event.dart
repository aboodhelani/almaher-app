part of 'library_bloc.dart';

abstract class LibraryEvent {
  const LibraryEvent();
}

class LibraryStarted extends LibraryEvent {
  const LibraryStarted();
}

/// Loads what can be downloaded (once, unless [force]).
class LibraryCatalogRequested extends LibraryEvent {
  final bool force;

  const LibraryCatalogRequested({this.force = false});
}

class EditionDownloadRequested extends LibraryEvent {
  final EditionModel edition;

  const EditionDownloadRequested(this.edition);
}

class EditionDeleted extends LibraryEvent {
  final String identifier;

  const EditionDeleted(this.identifier);
}

class SurahDownloadRequested extends LibraryEvent {
  final String reciter;
  final int surah;

  const SurahDownloadRequested(this.reciter, this.surah);
}

class _SurahProgressed extends LibraryEvent {
  final String key;
  final double progress;

  const _SurahProgressed(this.key, this.progress);
}

class SurahDeleted extends LibraryEvent {
  final String reciter;
  final int surah;

  const SurahDeleted(this.reciter, this.surah);
}

class LibrarySelectionChanged extends LibraryEvent {
  final String? tafsir;
  final String? translation;
  final String? reciter;

  const LibrarySelectionChanged({this.tafsir, this.translation, this.reciter});
}
