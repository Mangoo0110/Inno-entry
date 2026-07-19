import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/account.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/repo/auth_repo.dart';

final class LoginWithExistingAccount
    implements AsyncUsecase<AuthStatus, Account> {
  const LoginWithExistingAccount(this._repo);

  final AuthRepo _repo;

  @override
  AsyncRequest<AuthStatus> call(Account params) {
    return _repo.loginWithExistingAccount(account: params);
  }
}
