part of 'library_bloc.dart';

String surahKey(String reciter, int surah) => '$reciter:$surah';

/// A download that failed; a new instance each time so listeners fire once.
class LibraryFailure {
  final String code;

  LibraryFailure(this.code);
}

class LibraryState {
  final LibraryCatalogModel? catalog;
  final bool catalogLoading;
  final bool catalogError;

  /// Editions on the device, bundled ones first.
  final List<EditionModel> editions;
  final Set<String> downloadingEditions;

  /// reciter → surahs on the device.
  final Map<String, Set<int>> surahs;

  /// [surahKey] → progress (0..1) of surahs downloading now.
  final Map<String, double> surahProgress;

  final LibrarySelectionModel selection;
  final LibraryFailure? failure;

  const LibraryState({
    this.catalog,
    this.catalogLoading = false,
    this.catalogError = false,
    this.editions = bundledEditions,
    this.downloadingEditions = const {},
    this.surahs = const {},
    this.surahProgress = const {},
    this.selection = const LibrarySelectionModel(
      tafsir: 'ar.muyassar',
      translation: 'en.sahih',
      reciter: 'ar.abdulbasitmurattal',
    ),
    this.failure,
  });

  List<EditionModel> editionsOf(EditionType type) =>
      editions.where((e) => e.type == type).toList();

  bool hasEdition(String id) => editions.any((e) => e.identifier == id);

  bool hasSurah(String reciter, int surah) => surahs[reciter]?.contains(surah) ?? false;

  double? progressOf(String reciter, int surah) => surahProgress[surahKey(reciter, surah)];

  /// Reciters with at least one surah on the device, the selected one first.
  List<String> downloadedReciters() => {
    selection.reciter,
    ...surahs.keys.where((r) => surahs[r]!.isNotEmpty),
  }.toList();

  /// The reciter's display name (from the catalog when loaded).
  String reciterName(String id) {
    if (id == defaultReciter.identifier) return defaultReciter.name;
    final known = _reciterNames[id];
    if (known != null) return known;
    for (final r in catalog?.reciters ?? const <ReciterModel>[]) {
      if (r.identifier == id) return r.name;
    }
    return id;
  }

  LibraryState copyWith({
    LibraryCatalogModel? catalog,
    bool? catalogLoading,
    bool? catalogError,
    List<EditionModel>? editions,
    Set<String>? downloadingEditions,
    Map<String, Set<int>>? surahs,
    Map<String, double>? surahProgress,
    LibrarySelectionModel? selection,
    LibraryFailure? failure,
  }) => LibraryState(
    catalog: catalog ?? this.catalog,
    catalogLoading: catalogLoading ?? this.catalogLoading,
    catalogError: catalogError ?? this.catalogError,
    editions: editions ?? this.editions,
    downloadingEditions: downloadingEditions ?? this.downloadingEditions,
    surahs: surahs ?? this.surahs,
    surahProgress: surahProgress ?? this.surahProgress,
    selection: selection ?? this.selection,
    failure: failure,
  );
}

/// Names of the known reciters, so downloads show a name offline too.
const _reciterNames = {
  'ar.abdullahbasfar': 'عبد الله بصفر',
  'ar.abdurrahmaansudais': 'عبد الرحمن السديس',
  'ar.abdulsamad': 'عبد الباسط عبد الصمد (مجود)',
  'ar.shaatree': 'أبو بكر الشاطري',
  'ar.ahmedajamy': 'أحمد بن علي العجمي',
  'ar.alafasy': 'مشاري العفاسي',
  'ar.hanirifai': 'هاني الرفاعي',
  'ar.husary': 'محمود خليل الحصري',
  'ar.husarymujawwad': 'محمود خليل الحصري (مجود)',
  'ar.hudhaify': 'علي بن عبد الرحمن الحذيفي',
  'ar.ibrahimakhbar': 'إبراهيم الأخضر',
  'ar.mahermuaiqly': 'ماهر المعيقلي',
  'ar.muhammadayyoub': 'محمد أيوب',
  'ar.muhammadjibreel': 'محمد جبريل',
  'ar.saoodshuraym': 'سعود الشريم',
  'ar.parhizgar': 'شهريار پرهيزگار',
  'ar.aymanswoaid': 'أيمن سويد',
};
