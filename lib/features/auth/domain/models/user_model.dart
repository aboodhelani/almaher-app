/// The signed-in player's account.
class UserModel {
  final String id;
  final String email;
  final String name;

  const UserModel({required this.id, required this.email, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String? ?? '',
    email: json['email'] as String? ?? '',
    name: json['name'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};
}

/// Wins, draws and losses, for a profile or a leaderboard row.
class PlayerStatsModel {
  final int matches;
  final int wins;
  final int draws;
  final int losses;
  final int points;

  const PlayerStatsModel({
    this.matches = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.points = 0,
  });

  factory PlayerStatsModel.fromJson(Map<String, dynamic> json) =>
      PlayerStatsModel(
        matches: (json['matches'] as num?)?.toInt() ?? 0,
        wins: (json['wins'] as num?)?.toInt() ?? 0,
        draws: (json['draws'] as num?)?.toInt() ?? 0,
        losses: (json['losses'] as num?)?.toInt() ?? 0,
        points: (json['points'] as num?)?.toInt() ?? 0,
      );

  /// Share of matches won, 0–100.
  int get winRate => matches == 0 ? 0 : (wins * 100 / matches).round();
}

enum MatchOutcome { win, draw, loss }

/// One of the player's recent matches.
class RecentMatchModel {
  final String opponent;
  final int myScore;
  final int opponentScore;
  final MatchOutcome result;
  final DateTime finishedAt;

  const RecentMatchModel({
    required this.opponent,
    required this.myScore,
    required this.opponentScore,
    required this.result,
    required this.finishedAt,
  });

  factory RecentMatchModel.fromJson(Map<String, dynamic> json) =>
      RecentMatchModel(
        opponent: json['opponent'] as String? ?? '',
        myScore: (json['myScore'] as num?)?.toInt() ?? 0,
        opponentScore: (json['opponentScore'] as num?)?.toInt() ?? 0,
        result: switch (json['result']) {
          'win' => MatchOutcome.win,
          'draw' => MatchOutcome.draw,
          _ => MatchOutcome.loss,
        },
        finishedAt:
            DateTime.tryParse(json['finishedAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

/// The signed-in player's profile: account, totals, recent matches.
class ProfileModel {
  final UserModel user;
  final PlayerStatsModel stats;
  final List<RecentMatchModel> recent;

  const ProfileModel({
    required this.user,
    required this.stats,
    required this.recent,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final stats = Map<String, dynamic>.from(json['stats'] as Map? ?? const {});
    return ProfileModel(
      user: UserModel.fromJson(
        Map<String, dynamic>.from(json['user'] as Map? ?? const {}),
      ),
      stats: PlayerStatsModel.fromJson(stats),
      recent: [
        for (final r in stats['recent'] as List? ?? const [])
          RecentMatchModel.fromJson(Map<String, dynamic>.from(r as Map)),
      ],
    );
  }
}

class LeaderboardRowModel {
  final int rank;
  final String userId;
  final String name;
  final PlayerStatsModel stats;

  const LeaderboardRowModel({
    required this.rank,
    required this.userId,
    required this.name,
    required this.stats,
  });

  factory LeaderboardRowModel.fromJson(Map<String, dynamic> json) =>
      LeaderboardRowModel(
        rank: (json['rank'] as num?)?.toInt() ?? 0,
        userId: json['userId'] as String? ?? '',
        name: json['name'] as String? ?? '',
        stats: PlayerStatsModel.fromJson(json),
      );
}
