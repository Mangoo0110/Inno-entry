import 'account.dart';

sealed class AuthStatus {}

class Authenticated extends AuthStatus {
  final Account account;
  Authenticated(this.account);
}

class Unauthenticated extends AuthStatus {}
