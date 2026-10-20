import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/network/error/exceptions.dart';
import '../../../../../core/utils/constant/network_constant.dart';

/// The match server's account endpoints. Errors become [ServerException]
/// with the server's code (`email_taken`, `invalid_credentials`, …).
class AuthRemoteDataSource {
  final http.Client _client;

  AuthRemoteDataSource([http.Client? client])
    : _client = client ?? http.Client();

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) => _post('/auth/register', {
    'email': email,
    'password': password,
    'name': name,
  });

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) => _post('/auth/login', {'email': email, 'password': password});

  /// `{user, stats: {…, recent}}` for the token's account.
  Future<Map<String, dynamic>> me(String token) async {
    final res = await _send(
      () => _client.get(
        Uri.parse('$serverUrl/auth/me'),
        headers: {'authorization': 'Bearer $token'},
      ),
    );
    return _decode(res) as Map<String, dynamic>;
  }

  /// Deletes the token's account; [password] confirms it.
  Future<void> deleteAccount(String token, String password) async {
    final res = await _send(
      () => _client.delete(
        Uri.parse('$serverUrl/auth/me'),
        headers: {
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode({'password': password}),
      ),
    );
    _decode(res);
  }

  Future<List<dynamic>> leaderboard() async {
    final res = await _send(
      () => _client.get(Uri.parse('$serverUrl/leaderboard')),
    );
    return _decode(res) as List<dynamic>;
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, String> body,
  ) async {
    final res = await _send(
      () => _client.post(
        Uri.parse('$serverUrl$path'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(body),
      ),
    );
    return _decode(res) as Map<String, dynamic>;
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 10));
    } catch (_) {
      throw const ServerException('unreachable');
    }
  }

  dynamic _decode(http.Response res) {
    final dynamic body = res.body.isEmpty ? null : jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    if (res.statusCode == 401) throw const ServerException('unauthorized');
    final message = body is Map ? body['message'] : null;
    throw ServerException(message is String ? message : 'generic');
  }
}
