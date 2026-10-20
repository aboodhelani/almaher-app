import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/constant/local_storage_constants.dart';

class QuranSharedPrefs {
  final SharedPreferences _preferences;

  QuranSharedPrefs(this._preferences);

  /// __________ Last Read Page __________ ///
  int getLastReadPage() {
    return _preferences.getInt(lastReadPage) ?? 1;
  }

  Future<void> setLastReadPage(int page) async {
    await _preferences.setInt(lastReadPage, page);
  }
}
