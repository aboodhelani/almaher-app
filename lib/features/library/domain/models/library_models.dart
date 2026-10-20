enum EditionType {
  tafsir,
  translation;

  String get wire => name;
}

/// A tafsir or translation of the whole Quran (one text per ayah).
class EditionModel {
  final String identifier;
  final String name;
  final String englishName;
  final String language;
  final EditionType type;

  /// Shipped with the app (always available).
  final bool bundled;

  const EditionModel({
    required this.identifier,
    required this.name,
    required this.englishName,
    required this.language,
    required this.type,
    this.bundled = false,
  });

  bool get rtl => const {'ar', 'ur', 'fa', 'ug', 'ps', 'dv', 'ku', 'sd'}.contains(language);

  factory EditionModel.fromJson(Map<String, dynamic> json) => EditionModel(
    identifier: json['identifier'] as String,
    name: json['name'] as String? ?? '',
    englishName: json['englishName'] as String? ?? '',
    language: json['language'] as String? ?? '',
    type: json['type'] == 'tafsir' ? EditionType.tafsir : EditionType.translation,
  );
}

/// A reciter whose verse-by-verse recitation can be downloaded per surah.
class ReciterModel {
  final String identifier;
  final String name;
  final String englishName;

  const ReciterModel({
    required this.identifier,
    required this.name,
    required this.englishName,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) => ReciterModel(
    identifier: json['identifier'] as String,
    name: json['name'] as String? ?? '',
    englishName: json['englishName'] as String? ?? '',
  );
}

/// Everything that can be downloaded: tafsirs, translations, reciters.
class LibraryCatalogModel {
  final List<EditionModel> tafsirs;
  final List<EditionModel> translations;
  final List<ReciterModel> reciters;

  const LibraryCatalogModel({
    this.tafsirs = const [],
    this.translations = const [],
    this.reciters = const [],
  });
}

/// What the reader uses by default.
class LibrarySelectionModel {
  final String tafsir;
  final String translation;
  final String reciter;

  const LibrarySelectionModel({
    required this.tafsir,
    required this.translation,
    required this.reciter,
  });
}

/// Editions shipped in assets/quran/editions (see tool/build_editions.py).
const bundledEditions = [
  EditionModel(
    identifier: 'ar.muyassar',
    name: 'التفسير الميسر',
    englishName: 'King Fahad Quran Complex',
    language: 'ar',
    type: EditionType.tafsir,
    bundled: true,
  ),
  EditionModel(
    identifier: 'en.sahih',
    name: 'Saheeh International',
    englishName: 'Saheeh International',
    language: 'en',
    type: EditionType.translation,
    bundled: true,
  ),
];

/// The default reciter (not in the catalog's verse-by-verse list, but
/// served the same way).
const defaultReciter = ReciterModel(
  identifier: 'ar.abdulbasitmurattal',
  name: 'عبد الباسط عبد الصمد (مرتل)',
  englishName: 'Abdul Basit (Murattal)',
);
