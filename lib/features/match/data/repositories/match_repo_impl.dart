import 'package:dartz/dartz.dart';

import '../../../../core/network/error/exceptions.dart';
import '../../../../core/network/error/failures.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';
import '../../domain/repositories/match_repo.dart';
import '../data_sources/remote/match_socket_data_source.dart';

class MatchRepoImpl implements MatchRepo {
  final MatchSocketDataSource _socket;

  MatchRepoImpl(this._socket);

  @override
  Stream<MatchStateModel> get states =>
      _socket.states.map(MatchStateModel.fromJson);

  @override
  Future<Either<Failure, String>> createMatch(
    MatchMode mode, {
    String? code,
    bool asReferee = false,
  }) => _withCode('match:create', {
    'mode': mode.wire,
    'code': ?code,
    if (asReferee) 'role': 'referee',
  });

  @override
  Future<Either<Failure, void>> joinMatch({
    required String code,
    required JoinRole role,
    required String name,
  }) => _action('match:join', {'code': code, 'role': role.wire, 'name': name});

  @override
  Future<Either<Failure, String>> quickMatch({
    required JoinRole role,
    required String name,
    required MatchMode mode,
  }) => _withCode('match:quick', {
    'role': role.wire,
    'name': name,
    'mode': mode.wire,
  });

  @override
  Future<Either<Failure, void>> startMatch() => _action('match:start');

  @override
  Future<Either<Failure, void>> buzz() => _action('round:buzz');

  @override
  Future<Either<Failure, void>> judge({
    required bool correct,
    String? ref,
    MatchRole? player,
  }) => _action('round:judge', {
    'verdict': correct ? 'correct' : 'wrong',
    'ref': ?ref,
    'player': ?player?.wire,
  });

  @override
  Future<Either<Failure, void>> passBid() => _action('round:pass');

  @override
  Future<Either<Failure, void>> answerSide({required bool right}) =>
      _action('round:side', {'side': right ? 'right' : 'left'});

  @override
  Future<Either<Failure, void>> startRun() => _action('round:start_run');

  @override
  Future<Either<Failure, List<QuestionModel>>> setupQuestions(
    RoundType type, {
    bool generated = false,
  }) async {
    try {
      final ack = await _socket.emit(
        generated ? 'setup:suggest' : 'setup:bank',
        {'type': type.wire},
      );
      return Right([
        for (final q in ack['questions'] as List? ?? const [])
          if (q is Map) QuestionModel.fromJson(Map<String, dynamic>.from(q)),
      ]);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    }
  }

  @override
  Future<Either<Failure, void>> setRoundCounts(Map<RoundType, int> counts) =>
      _action('setup:rounds', {
        'counts': {for (final e in counts.entries) e.key.wire: e.value},
      });

  @override
  Future<Either<Failure, void>> setRoundQuestions(
    RoundType type,
    List<Map<String, dynamic>> questions,
  ) => _action('setup:set', {'type': type.wire, 'questions': questions});

  @override
  Future<Either<Failure, void>> publishMatch() => _action('setup:publish');

  @override
  Future<Either<Failure, void>> award(MatchRole? player) =>
      _action('round:award', {'player': player?.wire});

  @override
  Future<Either<Failure, void>> submitAnswer(int value) =>
      _action('round:answer', {'value': value});

  @override
  Future<Either<Failure, void>> reveal() => _action('round:reveal');

  @override
  Future<Either<Failure, void>> replaceQuestion() => _action('round:replace');

  @override
  Future<Either<Failure, MediaTokenModel>> mediaToken() async {
    try {
      final ack = await _socket.emit('media:token');
      return Right(
        MediaTokenModel(
          url: ack['url'] as String,
          token: ack['token'] as String,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    }
  }

  @override
  Future<Either<Failure, void>> nextQuestion() => _action('round:next');

  @override
  Future<Either<Failure, void>> adjustScore(MatchRole player, int delta) =>
      _action('referee:adjust', {'player': player.wire, 'delta': delta});

  @override
  Future<void> leave() async => _socket.disconnect();

  /// An action whose acknowledgement carries the match code.
  Future<Either<Failure, String>> _withCode(
    String event,
    Map<String, dynamic> body,
  ) async {
    try {
      final ack = await _socket.emit(event, body);
      return Right(ack['code'] as String);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    }
  }

  Future<Either<Failure, void>> _action(
    String event, [
    Map<String, dynamic>? body,
  ]) async {
    try {
      await _socket.emit(event, body);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.code));
    }
  }
}
