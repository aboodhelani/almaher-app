import 'failure.dart';

/// The server refused an action or could not be reached. [errorMessage] is
/// the server's error code (e.g. `role_taken`).
class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);
}
