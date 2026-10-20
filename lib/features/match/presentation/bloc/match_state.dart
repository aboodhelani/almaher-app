part of 'match_bloc.dart';

abstract class MatchState {
  const MatchState();
}

/// Not in a match yet; [error] is a server error code from the last attempt.
class MatchIdle extends MatchState {
  final String? error;

  const MatchIdle({this.error});
}

class MatchConnecting extends MatchState {
  const MatchConnecting();
}

class MatchInRoom extends MatchState {
  final MatchStateModel match;

  /// A refused action (server error code), shown once.
  final String? error;

  const MatchInRoom(this.match, {this.error});
}
