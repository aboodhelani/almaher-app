import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/data/data_sources/app_shared_prefs.dart';
import '../styles/quran_fonts.dart';

class AppNotifier extends ChangeNotifier {
  final AppSharedPrefs _prefs;
  bool _isDarkTheme;
  bool _showTajweed;
  bool _showSimilar;
  int _similarMinWords;
  bool _useTashkeelKeyboard;
  bool _gameSounds;
  QuranFont _quranFont;

  /// Range offered for [similarMinWords].
  static const minSimilarWords = 2;
  static const maxSimilarWords = 8;

  AppNotifier(this._prefs)
    : _isDarkTheme = _prefs.getIsDarkTheme(),
      _showTajweed = _prefs.getShowTajweed(),
      _showSimilar = _prefs.getShowSimilar(),
      _similarMinWords = _prefs.getSimilarMinWords(),
      _useTashkeelKeyboard = _prefs.getUseTashkeelKeyboard(),
      _gameSounds = _prefs.getGameSounds(),
      _quranFont = QuranFont.fromId(_prefs.getQuranFont()) {
    _applySystemOverlay();
  }

  bool get isDarkTheme => _isDarkTheme;

  /// The font the mushaf is set in.
  QuranFont get quranFont => _quranFont;

  void updateQuranFont(QuranFont font) {
    if (_quranFont == font) return;
    _quranFont = font;
    _prefs.setQuranFont(font.id);
    notifyListeners();
  }

  ThemeMode get themeMode => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  /// Whether the mushaf colours letters by tajweed rule.
  bool get showTajweed => _showTajweed;

  void updateShowTajweed(bool show) {
    if (_showTajweed == show) return;
    _showTajweed = show;
    _prefs.setShowTajweed(show);
    notifyListeners();
  }

  /// Whether the mushaf marks repeated ayahs and phrases.
  bool get showSimilar => _showSimilar;

  void updateShowSimilar(bool show) {
    if (_showSimilar == show) return;
    _showSimilar = show;
    _prefs.setShowSimilar(show);
    notifyListeners();
  }

  /// Fewest consecutive words two ayahs must share to count as similar.
  int get similarMinWords => _similarMinWords;

  void updateSimilarMinWords(int words) {
    final value = words.clamp(minSimilarWords, maxSimilarWords);
    if (_similarMinWords == value) return;
    _similarMinWords = value;
    _prefs.setSimilarMinWords(value);
    notifyListeners();
  }

  /// Whether search uses the in-app keyboard with tashkeel keys.
  bool get useTashkeelKeyboard => _useTashkeelKeyboard;

  void updateUseTashkeelKeyboard(bool use) {
    if (_useTashkeelKeyboard == use) return;
    _useTashkeelKeyboard = use;
    _prefs.setUseTashkeelKeyboard(use);
    notifyListeners();
  }

  /// Whether the competition plays its sound effects.
  bool get gameSounds => _gameSounds;

  void updateGameSounds(bool on) {
    if (_gameSounds == on) return;
    _gameSounds = on;
    _prefs.setGameSounds(on);
    notifyListeners();
  }

  void updateTheme(bool isDark) {
    if (_isDarkTheme == isDark) return;
    _isDarkTheme = isDark;
    _prefs.setDarkTheme(isDark);
    _applySystemOverlay();
    notifyListeners();
  }

  void _applySystemOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      _isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );
  }
}
