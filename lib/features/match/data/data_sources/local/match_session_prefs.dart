import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/constant/local_storage_constants.dart';
import '../../../domain/models/match_enums.dart';

/// The match this device is in, so reopening the app returns to it.
class MatchSession {
  final String code;
  final JoinRole role;
  final String name;

  const MatchSession({
    required this.code,
    required this.role,
    required this.name,
  });
}

class MatchSessionPrefs {
  final SharedPreferences _preferences;

  MatchSessionPrefs(this._preferences);

  /// __________ Current Match __________ ///
  MatchSession? get() {
    final code = _preferences.getString(matchSessionCode);
    final name = _preferences.getString(matchSessionName);
    final role = _preferences.getString(matchSessionRole);
    if (code == null || name == null || role == null) return null;
    return MatchSession(
      code: code,
      name: name,
      role: role == JoinRole.referee.wire ? JoinRole.referee : JoinRole.player,
    );
  }

  Future<void> save(MatchSession session) async {
    await _preferences.setString(matchSessionCode, session.code);
    await _preferences.setString(matchSessionName, session.name);
    await _preferences.setString(matchSessionRole, session.role.wire);
  }

  Future<void> clear() async {
    await _preferences.remove(matchSessionCode);
    await _preferences.remove(matchSessionName);
    await _preferences.remove(matchSessionRole);
  }
}
