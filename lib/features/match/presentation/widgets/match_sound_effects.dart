import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/game_sounds.dart';
import '../../../../core/utils/injections.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';
import '../bloc/match_bloc.dart';

/// Plays the competition's sounds as the match changes: a chime for each new
/// question, the buzzer, right / wrong verdicts, and the winner's fanfare.
/// (The last-seconds tick is played by the countdown.)
class MatchSoundEffects extends StatefulWidget {
  final Widget child;

  const MatchSoundEffects({super.key, required this.child});

  @override
  State<MatchSoundEffects> createState() => _MatchSoundEffectsState();
}

class _MatchSoundEffectsState extends State<MatchSoundEffects> {
  final _sounds = sl<GameSounds>();
  MatchStateModel? _last;

  @override
  void initState() {
    super.initState();
    _sounds.preload();
  }

  void _onState(MatchStateModel next) {
    final prev = _last;
    _last = next;
    if (prev == null) return;
    if (next.status == MatchStatus.finished &&
        prev.status != MatchStatus.finished) {
      _sounds.play(GameSound.win);
      return;
    }
    final a = prev.round;
    final b = next.round;
    if (b == null) return;
    if (a == null || a.index != b.index || (b.replaced && !a.replaced)) {
      _sounds.play(GameSound.question);
      return;
    }
    if (!a.revealed && b.revealed) {
      _sounds.play(b.awarded.isEmpty ? GameSound.wrong : GameSound.correct);
      return;
    }
    // A wrong answer: a new strike, or a buzzer answer judged wrong.
    int strikes(Map<MatchRole, int> s) => s.values.fold(0, (x, y) => x + y);
    if (strikes(b.strikes) > strikes(a.strikes) ||
        b.lockedOut.length > a.lockedOut.length) {
      _sounds.play(GameSound.wrong);
      return;
    }
    // ماذا تعرف: an answer ticked off.
    if (b.saidCount > a.saidCount) {
      _sounds.play(GameSound.correct);
      return;
    }
    if (a.activeBuzzer == null && b.activeBuzzer != null) {
      _sounds.play(GameSound.buzz);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MatchBloc, MatchState>(
      listener: (context, state) {
        if (state is MatchInRoom) _onState(state.match);
      },
      child: widget.child,
    );
  }
}
