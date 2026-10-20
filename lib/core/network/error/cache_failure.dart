import 'failure.dart';

/// Failures reading bundled assets or local storage.
class CacheFailure extends Failure {
  const CacheFailure(super.errorMessage);
}
