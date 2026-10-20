class ServerException implements Exception {
  /// The server's error code, e.g. `role_taken`, or `unreachable`.
  final String code;

  const ServerException(this.code);

  @override
  String toString() => 'ServerException: $code';
}
