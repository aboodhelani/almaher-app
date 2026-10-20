import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../../shared/data/data_sources/app_shared_prefs.dart';

enum GameSound { question, buzz, correct, wrong, tick, win }

/// The competition's sound effects (assets/sounds, made by
/// tool/make_sounds.py). Each sound has its own preloaded player so they
/// can overlap and start without delay. Silent when turned off in settings.
class GameSounds {
  final AppSharedPrefs _prefs;
  final Map<GameSound, AudioPlayer> _players = {};

  GameSounds(this._prefs);

  Future<AudioPlayer?> _player(GameSound sound) async {
    final existing = _players[sound];
    if (existing != null) return existing;
    try {
      final player = AudioPlayer();
      await player.setAsset('assets/sounds/${sound.name}.wav');
      _players[sound] = player;
      return player;
    } catch (e) {
      debugPrint('GameSounds: could not load ${sound.name}: $e');
      return null;
    }
  }

  /// Loads every sound ahead of time (when the match screen opens).
  Future<void> preload() async {
    for (final s in GameSound.values) {
      await _player(s);
    }
  }

  Future<void> play(GameSound sound) async {
    if (!_prefs.getGameSounds()) return;
    final player = await _player(sound);
    if (player == null) return;
    try {
      await player.seek(Duration.zero);
      await player.play();
    } catch (_) {}
  }
}
