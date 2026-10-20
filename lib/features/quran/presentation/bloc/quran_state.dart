part of 'quran_bloc.dart';

abstract class QuranState {
  const QuranState();
}

class QuranLoading extends QuranState {}

class QuranLoaded extends QuranState {
  final QuranModel quran;

  /// Page the reader opens on (the last one read).
  final int initialPage;
  final int currentPage;

  /// `surah:ayah` key of the highlighted ayah, if any.
  final String? highlightedAyahKey;

  /// Tajweed spans; `null` if they could not be loaded.
  final TajweedModel? tajweed;

  /// Repeated ayahs and phrases; `null` until loaded.
  final MutashabihatModel? mutashabihat;

  const QuranLoaded({
    required this.quran,
    required this.initialPage,
    required this.currentPage,
    this.highlightedAyahKey,
    this.tajweed,
    this.mutashabihat,
  });

  QuranLoaded copyWith({
    int? currentPage,
    String? highlightedAyahKey,
    bool clearHighlight = false,
    MutashabihatModel? mutashabihat,
  }) {
    return QuranLoaded(
      quran: quran,
      initialPage: initialPage,
      currentPage: currentPage ?? this.currentPage,
      highlightedAyahKey: clearHighlight
          ? null
          : highlightedAyahKey ?? this.highlightedAyahKey,
      tajweed: tajweed,
      mutashabihat: mutashabihat ?? this.mutashabihat,
    );
  }
}

class QuranError extends QuranState {
  final String message;

  const QuranError(this.message);
}
