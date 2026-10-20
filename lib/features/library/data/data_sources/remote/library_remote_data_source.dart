import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../../core/network/error/exceptions.dart';
import '../../../domain/models/library_models.dart';

/// api.alquran.cloud: the catalog of tafsirs, translations and reciters, a
/// whole edition's text, and a surah's recitation files.
class LibraryRemoteDataSource {
  static const _api = 'https://api.alquran.cloud/v1';
  final http.Client _client;

  LibraryRemoteDataSource([http.Client? client])
    : _client = client ?? http.Client();

  Future<List<EditionModel>> editions(EditionType type) async {
    final list = await _get('$_api/edition?type=${type.wire}') as List;
    return [
      for (final e in list) EditionModel.fromJson(Map<String, dynamic>.from(e as Map)),
    ];
  }

  /// Arabic verse-by-verse recitations (spoken translations left out, and
  /// the duplicate "-2" sources).
  Future<List<ReciterModel>> reciters() async {
    final list =
        await _get('$_api/edition?format=audio&type=versebyverse') as List;
    return [
      for (final e in list)
        if ((e as Map)['language'] == 'ar' &&
            !(e['identifier'] as String).endsWith('-2'))
          ReciterModel.fromJson(Map<String, dynamic>.from(e)),
    ];
  }

  /// A whole edition in the app's compact format (`texts`: 6236 strings).
  Future<Map<String, dynamic>> edition(String identifier) async {
    final data = await _get('$_api/quran/$identifier') as Map;
    final ed = Map<String, dynamic>.from(data['edition'] as Map);
    final texts = [
      for (final s in data['surahs'] as List)
        for (final a in (s as Map)['ayahs'] as List) (a as Map)['text'] as String,
    ];
    if (texts.length != 6236) throw const ServerException('bad_edition');
    return {...ed, 'texts': texts};
  }

  /// Each ayah's recitation URLs (main first, then fallbacks) for a surah.
  Future<List<List<String>>> surahAudio(String reciter, int surah) async {
    final data = await _get('$_api/surah/$surah/$reciter') as Map;
    return [
      for (final a in data['ayahs'] as List)
        [
          (a as Map)['audio'] as String,
          ...((a['audioSecondary'] as List?) ?? const []).cast<String>(),
        ],
    ];
  }

  /// Downloads [url] into [file] (via a temporary file, so a broken
  /// download never leaves a half file behind).
  Future<void> downloadFile(String url, File file) async {
    final tmp = File('${file.path}.part');
    try {
      final res = await _client
          .send(http.Request('GET', Uri.parse(url)))
          .timeout(const Duration(seconds: 30));
      if (res.statusCode != 200) throw const ServerException('download_failed');
      await tmp.parent.create(recursive: true);
      final sink = tmp.openWrite();
      await res.stream.pipe(sink);
      await tmp.rename(file.path);
    } on ServerException {
      rethrow;
    } catch (_) {
      if (await tmp.exists()) await tmp.delete();
      throw const ServerException('download_failed');
    }
  }

  Future<dynamic> _get(String url) async {
    try {
      final res = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 60));
      if (res.statusCode != 200) throw const ServerException('download_failed');
      final body = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      return body['data'];
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException('unreachable');
    }
  }
}
