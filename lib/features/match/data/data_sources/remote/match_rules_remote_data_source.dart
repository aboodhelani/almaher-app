import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/network/error/exceptions.dart';
import '../../../../../core/utils/constant/network_constant.dart';

/// The competition rules (GET /rules), for the how-to-play page.
class MatchRulesRemoteDataSource {
  final http.Client _client;

  MatchRulesRemoteDataSource([http.Client? client])
    : _client = client ?? http.Client();

  Future<Map<String, dynamic>> rules() async {
    try {
      final res = await _client
          .get(Uri.parse('$serverUrl/rules'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) throw const ServerException('generic');
      return Map<String, dynamic>.from(jsonDecode(res.body) as Map);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const ServerException('unreachable');
    }
  }
}
