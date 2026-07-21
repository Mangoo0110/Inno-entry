part of 'register_bloc.dart';

sealed class RegisterEvent {
  const RegisterEvent();
}

final class RegisterReset extends RegisterEvent {
  const RegisterReset();
}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({required this.accountName, required this.pin});

  final String accountName;
  final String pin;
}
