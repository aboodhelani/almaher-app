import 'tajweed_span_model.dart';

/// Tajweed spans for every ayah, keyed by `surah:ayah`. Within an ayah, outer
/// spans come before the spans nested inside them.
class TajweedModel {
  final Map<String, List<TajweedSpanModel>> _byAyah;

  const TajweedModel(this._byAyah);

  List<TajweedSpanModel> forAyah(String ayahKey) =>
      _byAyah[ayahKey] ?? const [];
}
