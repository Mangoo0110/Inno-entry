part of 'login_bloc.dart';

sealed class LoginEvent {
  const LoginEvent();
}

final class LoginReset extends LoginEvent {
  const LoginReset();
}

final class LoginNameSubmitted extends LoginEvent {
  const LoginNameSubmitted(this.accountName);

  final String accountName;
}

final class LoginPinDigitPressed extends LoginEvent {
  const LoginPinDigitPressed(this.digit);

  final String digit;
}

final class LoginPinBackspacePressed extends LoginEvent {
  const LoginPinBackspacePressed();
}

final class LoginUnlockSubmitted extends LoginEvent {
  const LoginUnlockSubmitted();
}
