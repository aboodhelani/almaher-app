import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/constant/local_storage_constants.dart';
import '../../domain/entities/language_enum.dart';

class AppSharedPrefs {
  final SharedPreferences _preferences;

  AppSharedPrefs(this._preferences);

  /// __________ Language __________ ///
  /// Arabic is the app's base language.
  LanguageEnum? getLang() {
    String? data = _preferences.getString(lang);
    if (data == null) {
      return LanguageEnum.ar;
    }
    return LanguageEnum.values.firstWhere(
      (element) => element.local == data,
      orElse: () => LanguageEnum.ar,
    );
  }

  void setLang(LanguageEnum language) {
    _preferences.setString(lang, language.local);
  }

  /// __________ Dark Theme __________ ///
  bool getIsDarkTheme() {
    return _preferences.getBool(theme) ?? false;
  }

  Future<void> setDarkTheme(bool value) async {
    await _preferences.setBool(theme, value);
  }

  /// __________ Tajweed Colours __________ ///
  /// On by default.
  bool getShowTajweed() {
    return _preferences.getBool(tajweedColors) ?? true;
  }

  Future<void> setShowTajweed(bool value) async {
    await _preferences.setBool(tajweedColors, value);
  }

  /// __________ Similar Ayahs __________ ///
  /// On by default.
  bool getShowSimilar() {
    return _preferences.getBool(similarColors) ?? true;
  }

  Future<void> setShowSimilar(bool value) async {
    await _preferences.setBool(similarColors, value);
  }

  /// Fewest consecutive words two ayahs must share to count as similar.
  int getSimilarMinWords() {
    return _preferences.getInt(similarMinWords) ?? 2;
  }

  Future<void> setSimilarMinWords(int value) async {
    await _preferences.setInt(similarMinWords, value);
  }

  /// __________ Mushaf font __________ ///
  /// The mushaf's font (a [QuranFont] id); the Hafs font by default.
  String? getQuranFont() => _preferences.getString(quranFont);

  Future<void> setQuranFont(String id) async {
    await _preferences.setString(quranFont, id);
  }

  /// __________ Search Keyboard __________ ///
  /// Whether search opens the in-app Arabic keyboard with tashkeel keys.
  bool getUseTashkeelKeyboard() {
    return _preferences.getBool(tashkeelKeyboard) ?? false;
  }

  Future<void> setUseTashkeelKeyboard(bool value) async {
    await _preferences.setBool(tashkeelKeyboard, value);
  }

  /// __________ Game Sounds __________ ///
  /// On by default.
  bool getGameSounds() => _preferences.getBool(gameSounds) ?? true;

  Future<void> setGameSounds(bool value) =>
      _preferences.setBool(gameSounds, value);
}
