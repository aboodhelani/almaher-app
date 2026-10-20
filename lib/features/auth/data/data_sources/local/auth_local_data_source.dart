import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/constant/local_storage_constants.dart';
import '../../../domain/models/user_model.dart';

/// The session on this device: the token in the keychain / keystore, the
/// account (name, email) in shared preferences for a quick start.
class AuthLocalDataSource {
  final FlutterSecureStorage _secure;
  final SharedPreferences _prefs;

  AuthLocalDataSource(this._prefs, [FlutterSecureStorage? secure])
    : _secure = secure ?? const FlutterSecureStorage();

  Future<String?> token() async {
    try {
      return await _secure.read(key: authToken);
    } catch (_) {
      return null;
    }
  }

  UserModel? user() {
    final raw = _prefs.getString(authUser);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(String token, UserModel user) async {
    await _secure.write(key: authToken, value: token);
    await _prefs.setString(authUser, jsonEncode(user.toJson()));
  }

  Future<void> clear() async {
    try {
      await _secure.delete(key: authToken);
    } catch (_) {}
    await _prefs.remove(authUser);
  }
}
