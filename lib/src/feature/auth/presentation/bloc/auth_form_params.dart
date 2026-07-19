part of 'auth_bloc.dart';

final class _AuthFormParams implements AuthParams {
  const _AuthFormParams({required this.accountName, required this.pin});

  @override
  final String accountName;

  @override
  final String pin;
}
