part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

/// Reads the session saved on this device.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// The server no longer accepts this device's token.
class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}
