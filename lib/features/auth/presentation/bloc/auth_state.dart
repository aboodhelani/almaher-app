part of 'auth_bloc.dart';

class AuthState {
  /// The signed-in account; null for a guest.
  final UserModel? user;

  /// The saved session has been read.
  final bool checked;
  final bool busy;

  /// Server error code from the last login / register attempt.
  final String? error;

  const AuthState({
    this.user,
    this.checked = false,
    this.busy = false,
    this.error,
  });

  bool get signedIn => user != null;

  AuthState copyWith({bool? busy, String? error}) => AuthState(
    user: user,
    checked: checked,
    busy: busy ?? this.busy,
    error: error,
  );
}
