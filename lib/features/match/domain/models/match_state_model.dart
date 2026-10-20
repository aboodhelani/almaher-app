import 'match_enums.dart';

class ParticipantModel {
  final String name;
  final bool connected;

  const ParticipantModel({required this.name, required this.connected});

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      ParticipantModel(
        name: json['name'] as String? ?? '',
        connected: json['connected'] as bool? ?? false,
      );
}

class PlayerAnswerModel {
  final bool submitted;

  /// Hidden (null) from players until the reveal, except their own.
  final int? value;

  /// How long they took to answer; sent to the referee only.
  final double? secondsTaken;

  const PlayerAnswerModel({
    required this.submitted,
    this.value,
    this.secondsTaken,
  });

  factory PlayerAnswerModel.fromJson(Map<String, dynamic>? json) =>
      PlayerAnswerModel(
        submitted: json?['submitted'] as bool? ?? false,
        value: (json?['value'] as num?)?.toInt(),
        secondsTaken: (json?['secondsTaken'] as num?)?.toDouble(),
      );
}

/// The five rounds, in the show's order.
enum RoundType {
  whatDoYouKnow('what_do_you_know'),
  ayahNumber('ayah_number'),
  auction('auction'),
  similar('similar'),
  sard('sard'),
  rightLeft('right_left'),
  buzzer('buzzer');

  final String wire;

  const RoundType(this.wire);

  static RoundType fromWire(String? value) =>
      values.firstWhere((t) => t.wire == value, orElse: () => buzzer);

  /// Players type a number (ayah count or bid).
  bool get usesNumbers => this == ayahNumber || this == auction;

  /// Players press a buzzer.
  bool get usesBuzzer => this == buzzer;
}

class QuestionRefModel {
  final int surah;
  final int ayah;
  final String surahName;
  final String text;

  /// ماذا تعرف: already given by a player.
  final bool said;

  const QuestionRefModel({
    required this.surah,
    required this.ayah,
    required this.surahName,
    required this.text,
    required this.said,
  });

  String get key => '$surah:$ayah';

  factory QuestionRefModel.fromJson(Map<String, dynamic> json) =>
      QuestionRefModel(
        surah: (json['surah'] as num?)?.toInt() ?? 0,
        ayah: (json['ayah'] as num?)?.toInt() ?? 0,
        surahName: json['surahName'] as String? ?? '',
        text: json['text'] as String? ?? '',
        said: json['said'] as bool? ?? false,
      );
}

/// The question being played. The answer key ([answer], [refs], [meta]) is
/// sent to the referee, and to everyone once the question is decided.
class QuestionModel {
  final String prompt;

  /// المزاد: how many answers exist (shown to everyone).
  final int? total;
  final String? answer;
  final List<QuestionRefModel> refs;
  final Map<String, dynamic> meta;

  /// الجرس: players don't see the question until it is decided; the referee
  /// reads it out.
  final bool hidden;

  const QuestionModel({
    required this.prompt,
    this.hidden = false,
    this.total,
    this.answer,
    this.refs = const [],
    this.meta = const {},
  });

  /// What the server needs to play this question again (setup).
  Map<String, dynamic> toBody() => {
    'prompt': prompt,
    'answer': ?answer,
    'refs': [
      for (final r in refs) {'surah': r.surah, 'ayah': r.ayah},
    ],
    'meta': meta,
  };

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    prompt: json['prompt'] as String? ?? '',
    total: (json['total'] as num?)?.toInt(),
    answer: json['answer'] as String?,
    refs: [
      for (final r in json['refs'] as List? ?? const [])
        if (_map(r) case final m?) QuestionRefModel.fromJson(m),
    ],
    meta: _map(json['meta']) ?? const {},
    hidden: json['promptHidden'] == true,
  );
}

/// يمين يسار: one player's run so far (players see theirs once it ends).
class RightLeftResultModel {
  final List<bool> correct;
  final int right;
  final bool finished;

  const RightLeftResultModel({
    required this.correct,
    required this.right,
    required this.finished,
  });

  factory RightLeftResultModel.fromJson(Map<String, dynamic> json) =>
      RightLeftResultModel(
        correct: [
          for (final c in json['correct'] as List? ?? const []) c == true,
        ],
        right: (json['right'] as num?)?.toInt() ?? 0,
        finished: json['finished'] == true,
      );
}

/// يمين يسار: whose run, its stage and progress, and results.
class RightLeftModel {
  final MatchRole player;

  /// Waiting for the referee to start the run, or showing openings.
  final bool running;
  final int index;
  final int perRun;
  final List<MatchRole> done;
  final Map<MatchRole, RightLeftResultModel?> results;

  /// The opening on screen now (referee only).
  final String? side;
  final int? page;
  final String? surahName;
  final int? ayah;

  const RightLeftModel({
    required this.player,
    required this.running,
    required this.index,
    required this.perRun,
    required this.done,
    required this.results,
    this.side,
    this.page,
    this.surahName,
    this.ayah,
  });

  factory RightLeftModel.fromJson(Map<String, dynamic> json) {
    final results = _map(json['results']) ?? const {};
    return RightLeftModel(
      player:
          MatchRole.fromWire(json['player'] as String?) ?? MatchRole.player1,
      running: json['stage'] == 'running',
      index: (json['index'] as num?)?.toInt() ?? 0,
      perRun: (json['perRun'] as num?)?.toInt() ?? 6,
      done: [
        for (final p in json['done'] as List? ?? const [])
          if (MatchRole.fromWire(p as String?) case final r?) r,
      ],
      results: {
        for (final p in [MatchRole.player1, MatchRole.player2])
          p: switch (_map(results[p.wire])) {
            final m? => RightLeftResultModel.fromJson(m),
            null => null,
          },
      },
      side: json['side'] as String?,
      page: (json['page'] as num?)?.toInt(),
      surahName: json['surahName'] as String?,
      ayah: (json['ayah'] as num?)?.toInt(),
    );
  }
}

/// One round of a match as played: its type and how many questions.
class RoundSegment {
  final RoundType type;
  final int count;

  const RoundSegment(this.type, this.count);
}

class RoundModel {
  final RoundType type;

  /// Position in the whole match (0-based) and its length (20).
  final int index;
  final int total;

  /// Which round (0–4) and which question in it (0–3), of [roundSize].
  final int roundIndex;
  final int roundTotal;
  final int indexInRound;
  final int roundSize;

  /// The match's rounds as played, in order, with their question counts.
  final List<RoundSegment> segments;

  final bool revealed;
  final int secondsLeft;
  final int timeLimitSeconds;
  final QuestionModel question;
  final Map<MatchRole, PlayerAnswerModel> answers;

  /// Players who got the point, once decided.
  final List<MatchRole> awarded;

  /// Who answered (or buzzed) first; sent to the referee only.
  final MatchRole? firstAnswered;

  /// ماذا تعرف: whose turn, and answers given so far.
  final MatchRole turn;
  final int saidCount;

  /// ماذا تعرف: wrong answers per player; the [maxStrikes]th gives the other
  /// player the point.
  final Map<MatchRole, int> strikes;
  final int maxStrikes;

  /// ماذا تعرف: players who used their one pass on this question.
  final List<MatchRole> passed;

  /// المزاد: who holds the highest bid, and who recites once bidding closes.
  final MatchRole? highBidder;
  final MatchRole? reciter;

  /// الجرس: who is answering now, and who was wrong. المتشابهات: who used
  /// up their strikes.
  final MatchRole? activeBuzzer;
  final List<MatchRole> lockedOut;

  /// المتشابهات: what a correct answer is worth right now.
  final int? worth;

  /// The referee swapped this question for an alternative.
  final bool replaced;

  /// An extra question because the scores were level at the end.
  final bool tiebreak;

  /// يمين يسار: the runs.
  final RightLeftModel? rightLeft;

  /// Points each awarded player got.
  final int points;

  const RoundModel({
    required this.type,
    required this.index,
    required this.total,
    required this.roundIndex,
    required this.roundTotal,
    required this.indexInRound,
    this.roundSize = 4,
    this.segments = const [],
    required this.revealed,
    required this.secondsLeft,
    required this.timeLimitSeconds,
    required this.question,
    required this.answers,
    required this.awarded,
    required this.turn,
    required this.strikes,
    required this.saidCount,
    this.firstAnswered,
    this.highBidder,
    this.reciter,
    this.activeBuzzer,
    this.maxStrikes = 3,
    this.passed = const [],
    this.lockedOut = const [],
    this.worth,
    this.points = 1,
    this.replaced = false,
    this.tiebreak = false,
    this.rightLeft,
  });

  bool get isLastQuestion => index + 1 >= total;

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    final answers = _map(json['answers']) ?? const {};
    final strikes = _map(json['strikes']) ?? const {};
    List<MatchRole> roles(Object? v) => [
      for (final a in v as List? ?? const [])
        if (MatchRole.fromWire(a as String?) case final role?) role,
    ];
    return RoundModel(
      type: RoundType.fromWire(json['type'] as String?),
      index: (json['index'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      roundIndex: (json['roundIndex'] as num?)?.toInt() ?? 0,
      roundTotal: (json['roundTotal'] as num?)?.toInt() ?? 5,
      indexInRound: (json['indexInRound'] as num?)?.toInt() ?? 0,
      roundSize: (json['roundSize'] as num?)?.toInt() ?? 4,
      segments: [
        for (final s in json['segments'] as List? ?? const [])
          if (_map(s) case final m?)
            RoundSegment(
              RoundType.fromWire(m['type'] as String?),
              (m['count'] as num?)?.toInt() ?? 0,
            ),
      ],
      revealed: json['phase'] == 'revealed',
      secondsLeft: (json['secondsLeft'] as num?)?.toInt() ?? 0,
      timeLimitSeconds: (json['timeLimitSeconds'] as num?)?.toInt() ?? 60,
      question: QuestionModel.fromJson(_map(json['question']) ?? const {}),
      answers: {
        MatchRole.player1: PlayerAnswerModel.fromJson(_map(answers['player1'])),
        MatchRole.player2: PlayerAnswerModel.fromJson(_map(answers['player2'])),
      },
      awarded: roles(json['awarded']),
      firstAnswered: MatchRole.fromWire(json['firstAnswered'] as String?),
      turn: MatchRole.fromWire(json['turn'] as String?) ?? MatchRole.player1,
      strikes: {
        MatchRole.player1: (strikes['player1'] as num?)?.toInt() ?? 0,
        MatchRole.player2: (strikes['player2'] as num?)?.toInt() ?? 0,
      },
      saidCount: (json['saidCount'] as num?)?.toInt() ?? 0,
      highBidder: MatchRole.fromWire(json['highBidder'] as String?),
      reciter: MatchRole.fromWire(json['reciter'] as String?),
      activeBuzzer: MatchRole.fromWire(json['activeBuzzer'] as String?),
      maxStrikes: (json['maxStrikes'] as num?)?.toInt() ?? 3,
      passed: roles(json['passed']),
      lockedOut: roles(json['lockedOut']),
      worth: (json['worth'] as num?)?.toInt(),
      points: (json['points'] as num?)?.toInt() ?? 1,
      replaced: json['replaced'] == true,
      tiebreak: json['tiebreak'] == true,
      rightLeft: switch (_map(json['rightLeft'])) {
        final m? => RightLeftModel.fromJson(m),
        null => null,
      },
    );
  }
}

/// A match as this device's role may see it (see the server's `snapshotFor`).
class MatchStateModel {
  final String code;
  final MatchMode mode;
  final MatchStatus status;
  final MatchRole you;
  final Map<MatchRole, ParticipantModel> participants;
  final Map<MatchRole, int> scores;
  final RoundModel? round;

  /// False while the referee prepares the match (players can't join yet).
  final bool published;

  /// Questions per round by default, and the referee's chosen ones while
  /// preparing.
  final int perRound;

  /// The rounds this match plays and how many questions each (the referee
  /// picks them while preparing).
  final List<RoundType> rounds;
  final Map<RoundType, int> roundCounts;

  /// The rounds the referee may pick from (the dashboard may turn some off),
  /// and the most questions in a round and in the whole match.
  final List<RoundType> availableRounds;
  final int maxPerRound;
  final int maxQuestions;
  final Map<RoundType, List<QuestionModel>> setup;

  /// player1, player2, or null for a draw; only when finished.
  final MatchRole? winner;
  final bool isDraw;

  /// When this snapshot arrived, to count [RoundModel.secondsLeft] down.
  final DateTime receivedAt;

  const MatchStateModel({
    required this.code,
    required this.mode,
    required this.status,
    required this.you,
    required this.participants,
    required this.scores,
    required this.round,
    required this.winner,
    required this.isDraw,
    required this.receivedAt,
    this.published = true,
    this.perRound = 4,
    this.rounds = RoundType.values,
    this.roundCounts = const {},
    this.availableRounds = RoundType.values,
    this.maxPerRound = 30,
    this.maxQuestions = 60,
    this.setup = const {},
  });

  /// Questions [type] has in this match (0 when it is not played).
  int countFor(RoundType type) =>
      roundCounts[type] ?? (rounds.contains(type) ? perRound : 0);

  /// Questions in the whole match (tie-breakers aside).
  int get totalQuestions => rounds.fold(0, (sum, t) => sum + countFor(t));

  /// The referee is still preparing this match.
  bool get isDraft => status == MatchStatus.lobby && !published;

  bool get bothPlayersJoined =>
      participants.containsKey(MatchRole.player1) &&
      participants.containsKey(MatchRole.player2);

  factory MatchStateModel.fromJson(Map<String, dynamic> json) {
    final parts = _map(json['participants']) ?? const {};
    final scores = _map(json['scores']) ?? const {};
    final round = _map(json['round']);
    final setup = _map(json['setup']) ?? const {};
    return MatchStateModel(
      published: json['published'] != false,
      perRound: (json['perRound'] as num?)?.toInt() ?? 4,
      rounds: json['rounds'] is List
          ? [
              for (final w in json['rounds'] as List)
                RoundType.fromWire(w as String?),
            ]
          : RoundType.values,
      roundCounts: {
        for (final e in (_map(json['roundCounts']) ?? const {}).entries)
          if ((e.value as num?)?.toInt() case final n? when n > 0)
            RoundType.fromWire(e.key): n,
      },
      availableRounds: json['availableRounds'] is List
          ? [
              for (final w in json['availableRounds'] as List)
                RoundType.fromWire(w as String?),
            ]
          : RoundType.values,
      maxPerRound: (json['maxPerRound'] as num?)?.toInt() ?? 30,
      maxQuestions: (json['maxQuestions'] as num?)?.toInt() ?? 60,
      setup: {
        for (final e in setup.entries)
          RoundType.fromWire(e.key): [
            for (final q in e.value as List? ?? const [])
              if (_map(q) case final m?) QuestionModel.fromJson(m),
          ],
      },
      code: json['code'] as String? ?? '',
      mode: MatchMode.fromWire(json['mode'] as String?),
      status: switch (json['status']) {
        'playing' => MatchStatus.playing,
        'finished' => MatchStatus.finished,
        _ => MatchStatus.lobby,
      },
      you: MatchRole.fromWire(json['you'] as String?) ?? MatchRole.player1,
      participants: {
        for (final e in parts.entries)
          if (MatchRole.fromWire(e.key) case final role?)
            role: ParticipantModel.fromJson(_map(e.value)!),
      },
      scores: {
        MatchRole.player1: (scores['player1'] as num?)?.toInt() ?? 0,
        MatchRole.player2: (scores['player2'] as num?)?.toInt() ?? 0,
      },
      round: round == null ? null : RoundModel.fromJson(round),
      winner: MatchRole.fromWire(json['winner'] as String?),
      isDraw: json['winner'] == 'draw',
      receivedAt: DateTime.now(),
    );
  }
}

/// Any decoded JSON object as `Map<String, dynamic>`, or null.
Map<String, dynamic>? _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

/// Where and how to join a remote match's audio/video room (LiveKit).
class MediaTokenModel {
  final String url;
  final String token;

  const MediaTokenModel({required this.url, required this.token});
}
