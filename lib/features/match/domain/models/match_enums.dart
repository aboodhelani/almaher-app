/// A seat in a match. [wire] is the server's name for it.
enum MatchRole {
  player1('player1'),
  player2('player2'),
  referee('referee');

  final String wire;

  const MatchRole(this.wire);

  bool get isPlayer => this != referee;

  static MatchRole? fromWire(String? value) {
    for (final r in values) {
      if (r.wire == value) return r;
    }
    return null;
  }
}

/// What a user picks when entering: a player (the server chooses the first
/// or second seat) or the referee.
enum JoinRole {
  player('player'),
  referee('referee');

  final String wire;

  const JoinRole(this.wire);
}

/// Together on stage (phones are buttons only) or apart (live audio/video).
enum MatchMode {
  sameRoom('same_room'),
  remote('remote');

  final String wire;

  const MatchMode(this.wire);

  static MatchMode fromWire(String? value) =>
      value == remote.wire ? remote : sameRoom;
}

enum MatchStatus { lobby, playing, finished }
