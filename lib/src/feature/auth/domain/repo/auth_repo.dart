import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/signup_params.dart';

import '../entities/account.dart';
import '../entities/login_params.dart';

abstract interface class AuthRepo {
  Stream<AuthStatus> watchAuthStatus();

  AsyncRequest<bool> isAccountNameAvailable(String accountName);

  /// Creates a new account, and returns [Authenticated] if successful, or else [Unauthenticated]
  AsyncRequest<AuthStatus> createAccount({required SignUpParams params});

  /// Tries to unlock an account, and returns [Authenticated] if successful, or else [Unauthenticated]
  AsyncRequest<AuthStatus> unlockAccount({required LoginParams params});

  /// Returns a list of all accounts
  AsyncRequest<List<Account>> accounts();

  AsyncRequest<AuthStatus> loginWithExistingAccount({required Account account});

  AsyncRequest<AuthStatus> logout();

  AsyncRequest<AuthStatus> deleteCurrentAccount();
}
