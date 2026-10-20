part of 'match_bloc.dart';

abstract class MatchEvent {
  const MatchEvent();
}

/// Enter a match: by [code] (that exact match, created if missing) or, with
/// no code, wherever the server matches the user.
class MatchEnterRequested extends MatchEvent {
  final String name;
  final JoinRole role;
  final String? code;

  /// Used when a match is created for this user.
  final MatchMode mode;

  const MatchEnterRequested({
    required this.name,
    required this.role,
    required this.mode,
    this.code,
  });
}

class MatchStateReceived extends MatchEvent {
  final MatchStateModel state;

  const MatchStateReceived(this.state);
}

class MatchStartRequested extends MatchEvent {
  const MatchStartRequested();
}

class MatchBuzzed extends MatchEvent {
  const MatchBuzzed();
}

class MatchJudged extends MatchEvent {
  final bool correct;
  final String? ref;

  /// المتشابهات: who answered.
  final MatchRole? player;

  const MatchJudged({required this.correct, this.ref, this.player});
}

/// يمين يسار: the player answers right (true) or left.
class MatchSideAnswered extends MatchEvent {
  final bool right;

  const MatchSideAnswered({required this.right});
}

/// يمين يسار: the referee starts the waiting player's run.
class MatchRunStarted extends MatchEvent {
  const MatchRunStarted();
}

/// Referee, preparing: the rounds the match plays and their question counts.
class MatchRoundCountsSet extends MatchEvent {
  final Map<RoundType, int> counts;

  const MatchRoundCountsSet(this.counts);
}

/// Referee, preparing: the questions chosen for a round.
class MatchRoundQuestionsSet extends MatchEvent {
  final RoundType type;
  final List<Map<String, dynamic>> questions;

  const MatchRoundQuestionsSet(this.type, this.questions);
}

/// Referee: opens the prepared match to players.
class MatchPublishRequested extends MatchEvent {
  const MatchPublishRequested();
}

/// ماذا تعرف: pass this turn (the referee passes for the player whose turn
/// it is). المزاد: let the highest bidder recite.
class MatchBidPassed extends MatchEvent {
  const MatchBidPassed();
}

/// Ends the question: a point to [player], or none when null.
class MatchPointAwarded extends MatchEvent {
  final MatchRole? player;

  const MatchPointAwarded(this.player);
}

class MatchAnswerSubmitted extends MatchEvent {
  final int value;

  const MatchAnswerSubmitted(this.value);
}

class MatchReplaceRequested extends MatchEvent {
  const MatchReplaceRequested();
}

class MatchRevealRequested extends MatchEvent {
  const MatchRevealRequested();
}

class MatchNextRequested extends MatchEvent {
  const MatchNextRequested();
}

class MatchScoreAdjusted extends MatchEvent {
  final MatchRole player;
  final int delta;

  const MatchScoreAdjusted(this.player, this.delta);
}

class MatchErrorShown extends MatchEvent {
  const MatchErrorShown();
}

class MatchLeft extends MatchEvent {
  const MatchLeft();
}

/// Reopens the saved match, if any (see MatchSessionPrefs).
class MatchResumeRequested extends MatchEvent {
  const MatchResumeRequested();
}
