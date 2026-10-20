import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/usecases/library_usecases.dart';

/// Plays a downloaded surah ayah by ayah, from any ayah to the surah's end.
/// The reader follows [ayahKey] to highlight the ayah being recited.
class RecitationPlayer extends ChangeNotifier {
  final GetSurahFilesUseCase _getSurahFiles;
  final AudioPlayer _player = AudioPlayer();
  final List<StreamSubscription> _subs = [];

  String? _reciter;
  int? _surah;
  int? _ayah;
  bool _playing = false;

  RecitationPlayer(this._getSurahFiles) {
    _subs.add(_player.currentIndexStream.listen((i) {
      if (i == null || _surah == null) return;
      _ayah = i + 1;
      notifyListeners();
    }));
    _subs.add(_player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed) {
        stop();
        return;
      }
      if (s.playing != _playing) {
        _playing = s.playing;
        notifyListeners();
      }
    }));
  }

  String? get reciter => _reciter;
  int? get surah => _surah;
  int? get ayah => _ayah;
  bool get playing => _playing;
  bool get active => _surah != null;

  /// `surah:ayah` of the ayah being recited, or null.
  String? get ayahKey => _surah == null || _ayah == null ? null : '$_surah:$_ayah';

  /// Starts [surah] at [fromAyah]; false when the surah is not downloaded.
  Future<bool> play({
    required String reciter,
    required int surah,
    required int ayahCount,
    required int fromAyah,
  }) async {
    final result = await _getSurahFiles.call(
      SurahFilesParams(reciter, surah, ayahCount),
    );
    final files = result.fold((_) => null, (f) => f);
    if (files == null) return false;
    try {
      await _player.setAudioSources(
        [for (final f in files) AudioSource.file(f)],
        initialIndex: fromAyah - 1,
      );
    } catch (e) {
      debugPrint('RecitationPlayer: $e');
      return false;
    }
    _reciter = reciter;
    _surah = surah;
    _ayah = fromAyah;
    notifyListeners();
    unawaited(_player.play());
    return true;
  }

  void toggle() => _player.playing ? _player.pause() : _player.play();

  Future<void> next() async {
    if (_player.hasNext) await _player.seekToNext();
  }

  Future<void> previous() async {
    if (_player.hasPrevious) await _player.seekToPrevious();
  }

  Future<void> stop() async {
    await _player.stop();
    _reciter = null;
    _surah = null;
    _ayah = null;
    _playing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }
}
