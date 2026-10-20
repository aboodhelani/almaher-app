import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../../../core/network/error/exceptions.dart';
import '../../../../../core/utils/constant/network_constant.dart';

/// The match server's Socket.IO connection. Every action is acknowledged by
/// the server with `{ok: true, ...}` or `{ok: false, error: <code>}`.
class MatchSocketDataSource {
  /// The signed-in account's token, sent in the handshake (the server only
  /// lets accounts play).
  final Future<String?> Function()? token;

  MatchSocketDataSource({this.token});

  io.Socket? _socket;
  final _states = StreamController<Map<String, dynamic>>.broadcast();

  /// The last successful `match:join`, re-sent when the connection comes
  /// back (app back from the background, network restored).
  Map<String, dynamic>? _lastJoin;

  Stream<Map<String, dynamic>> get states => _states.stream;

  Future<io.Socket> _connected() async {
    final existing = _socket;
    if (existing != null && existing.connected) return existing;
    existing?.dispose();

    final authToken = await token?.call();
    final socket = io.io(
      serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': ?authToken})
          // The library caches one connection per URL; without this a match
          // joined after leaving another would reuse the disposed socket.
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );
    socket.on('match:state', (data) {
      if (data is Map) _states.add(Map<String, dynamic>.from(data));
    });
    socket.onReconnect((_) {
      final join = _lastJoin;
      if (join != null) socket.emit('match:join', join);
    });
    final ready = Completer<void>();
    socket.onConnect((_) {
      if (!ready.isCompleted) ready.complete();
    });
    socket.onConnectError((_) {
      if (!ready.isCompleted) {
        ready.completeError(const ServerException('unreachable'));
      }
    });
    socket.connect();
    _socket = socket;
    await ready.future.timeout(
      const Duration(seconds: 6),
      onTimeout: () => throw const ServerException('unreachable'),
    );
    return socket;
  }

  /// Sends [event] and returns the server's acknowledgement payload.
  Future<Map<String, dynamic>> emit(
    String event, [
    Map<String, dynamic>? body,
  ]) async {
    final socket = await _connected();
    final dynamic ack = await socket
        .emitWithAckAsync(event, body ?? const {})
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw const ServerException('timeout'),
        );
    final map = ack is Map
        ? Map<String, dynamic>.from(ack)
        : <String, dynamic>{};
    if (map['ok'] != true) {
      throw ServerException(map['error'] as String? ?? 'unknown');
    }
    if (event == 'match:join' || event == 'match:quick') {
      // Rejoin the exact seat later: by code, as the role the server gave.
      _lastJoin = {
        'code': map['code'] ?? body?['code'],
        'role': map['role'] ?? body?['role'],
        'name': body?['name'],
      };
    }
    return map;
  }

  void disconnect() {
    _lastJoin = null;
    _socket?.dispose();
    _socket = null;
  }
}
