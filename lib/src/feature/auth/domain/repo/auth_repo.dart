import '../../../../core/async_handlers/async_request.dart';
import '../entities/auth_status.dart';
import '../entities/account.dart';
import '../entities/auth_params.dart';

abstract interface class AuthRepo {
  Stream<AuthStatus> watchAuthStatus();

  AsyncRequest<bool> isAccountNameAvailable(String accountName);

  /// Creates a new account, and returns [Authenticated] if successful, or else [UnAuthenticated]
  AsyncRequest<AuthStatus> createAccount({required AuthParams params});

  /// Tries to unlock an account, and returns [Authenticated] if successful, or else [UnAuthenticated]
  AsyncRequest<AuthStatus> unlockAccount({required AuthParams params});

  /// Returns a list of all accounts
  AsyncRequest<List<Account>> accounts();

  AsyncRequest<AuthStatus> loginWithExistingAccount({required Account account});

  AsyncRequest<AuthStatus> logout();

  AsyncRequest<AuthStatus> deleteCurrentAccount();
}
