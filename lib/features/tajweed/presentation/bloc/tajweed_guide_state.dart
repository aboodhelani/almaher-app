part of 'tajweed_guide_bloc.dart';

/// The first place a rule occurs in the mushaf.
class TajweedExample {
  final AyahModel ayah;
  final SurahModel surah;
  final TajweedSpanModel span;

  const TajweedExample({
    required this.ayah,
    required this.surah,
    required this.span,
  });
}

abstract class TajweedGuideState {
  const TajweedGuideState();
}

class TajweedGuideLoading extends TajweedGuideState {}

class TajweedGuideLoaded extends TajweedGuideState {
  final Map<TajweedRule, TajweedExample> examples;

  const TajweedGuideLoaded(this.examples);
}
