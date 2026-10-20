import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/constant/local_storage_constants.dart';
import '../../../domain/models/library_models.dart';

/// Downloaded tafsirs / translations (`documents/editions/{id}.json`, the
/// compact format) and recitations (`documents/audio/{reciter}/{surah}/
/// {ayah}.mp3`, with a `complete` marker once a surah is whole), plus the
/// reader's chosen tafsir, translation and reciter.
class LibraryLocalDataSource {
  final SharedPreferences _prefs;
  final Map<String, List<String>> _texts = {};
  Directory? _docs;

  LibraryLocalDataSource(this._prefs);

  Future<Directory> _root() async =>
      _docs ??= await getApplicationDocumentsDirectory();

  Future<File> _editionFile(String id) async =>
      File('${(await _root()).path}/editions/$id.json');

  Future<Directory> _surahDir(String reciter, int surah) async =>
      Directory('${(await _root()).path}/audio/$reciter/$surah');

  // ── Editions ──

  /// Editions on this device: the bundled ones, then the downloaded ones
  /// (their names kept in a small index, so listing never reads the texts).
  List<EditionModel> downloadedEditions() => [
    ...bundledEditions,
    for (final raw in _prefs.getStringList(downloadedEditionsIndex) ?? const <String>[])
      EditionModel.fromJson(jsonDecode(raw) as Map<String, dynamic>),
  ];

  Future<void> saveEdition(Map<String, dynamic> edition) async {
    final id = edition['identifier'] as String;
    final file = await _editionFile(id);
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(edition));
    _texts.remove(id);
    final meta = Map<String, dynamic>.from(edition)..remove('texts');
    await _writeIndex([
      ...downloadedEditions().where((e) => !e.bundled && e.identifier != id).map(_meta),
      meta,
    ]);
  }

  Map<String, dynamic> _meta(EditionModel e) => {
    'identifier': e.identifier,
    'name': e.name,
    'englishName': e.englishName,
    'language': e.language,
    'type': e.type.wire,
  };

  Future<void> _writeIndex(List<Map<String, dynamic>> metas) =>
      _prefs.setStringList(downloadedEditionsIndex, [for (final m in metas) jsonEncode(m)]);

  Future<void> deleteEdition(String id) async {
    final file = await _editionFile(id);
    if (await file.exists()) await file.delete();
    _texts.remove(id);
    await _writeIndex([
      ...downloadedEditions().where((e) => !e.bundled && e.identifier != id).map(_meta),
    ]);
  }

  /// The edition's 6236 texts (bundled asset or downloaded file), cached.
  Future<List<String>> editionTexts(String id) async {
    final cached = _texts[id];
    if (cached != null) return cached;
    final String raw;
    if (bundledEditions.any((e) => e.identifier == id)) {
      raw = await rootBundle.loadString('assets/quran/editions/$id.json');
    } else {
      raw = await (await _editionFile(id)).readAsString();
    }
    final texts = ((jsonDecode(raw) as Map)['texts'] as List).cast<String>();
    return _texts[id] = texts;
  }

  // ── Recitations ──

  Future<File> ayahAudio(String reciter, int surah, int ayah) async =>
      File('${(await _surahDir(reciter, surah)).path}/$ayah.mp3');

  Future<bool> isSurahDownloaded(String reciter, int surah) async =>
      File('${(await _surahDir(reciter, surah)).path}/complete').exists();

  Future<void> markSurahComplete(String reciter, int surah) async {
    final dir = await _surahDir(reciter, surah);
    await File('${dir.path}/complete').writeAsString('ok');
  }

  Future<void> deleteSurah(String reciter, int surah) async {
    final dir = await _surahDir(reciter, surah);
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  /// reciter → surahs fully downloaded.
  Future<Map<String, Set<int>>> downloadedSurahs() async {
    final root = Directory('${(await _root()).path}/audio');
    final result = <String, Set<int>>{};
    if (!await root.exists()) return result;
    await for (final r in root.list()) {
      if (r is! Directory) continue;
      final reciter = r.uri.pathSegments.where((s) => s.isNotEmpty).last;
      await for (final s in r.list()) {
        if (s is! Directory) continue;
        final surah = int.tryParse(s.uri.pathSegments.where((x) => x.isNotEmpty).last);
        if (surah != null && await File('${s.path}/complete').exists()) {
          (result[reciter] ??= {}).add(surah);
        }
      }
    }
    return result;
  }

  // ── Selection ──

  LibrarySelectionModel selection() => LibrarySelectionModel(
    tafsir: _prefs.getString(selectedTafsir) ?? 'ar.muyassar',
    translation: _prefs.getString(selectedTranslation) ?? 'en.sahih',
    reciter: _prefs.getString(selectedReciter) ?? defaultReciter.identifier,
  );

  Future<void> select({String? tafsir, String? translation, String? reciter}) async {
    if (tafsir != null) await _prefs.setString(selectedTafsir, tafsir);
    if (translation != null) await _prefs.setString(selectedTranslation, translation);
    if (reciter != null) await _prefs.setString(selectedReciter, reciter);
  }
}
