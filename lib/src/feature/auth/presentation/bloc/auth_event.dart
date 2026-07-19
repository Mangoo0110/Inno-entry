part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthLoginSelected extends AuthEvent {
  const AuthLoginSelected();
}

final class AuthCreateAccountSelected extends AuthEvent {
  const AuthCreateAccountSelected();
}

final class AuthBackPressed extends AuthEvent {
  const AuthBackPressed();
}

final class AuthNameSubmitted extends AuthEvent {
  const AuthNameSubmitted(this.accountName);

  final String accountName;
}

final class AuthCreateAccountSubmitted extends AuthEvent {
  const AuthCreateAccountSubmitted({
    required this.accountName,
    required this.pin,
  });

  final String accountName;
  final String pin;
}

final class AuthPinDigitPressed extends AuthEvent {
  const AuthPinDigitPressed(this.digit);

  final String digit;
}

final class AuthPinBackspacePressed extends AuthEvent {
  const AuthPinBackspacePressed();
}

final class AuthUnlockSubmitted extends AuthEvent {
  const AuthUnlockSubmitted();
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class _AuthStatusChanged extends AuthEvent {
  const _AuthStatusChanged(this.status);

  final AuthStatus status;
}
