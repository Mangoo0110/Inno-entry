import 'package:inno_entry/src/core/async_handlers/async_request.dart';
import 'package:inno_entry/src/core/async_handlers/response.dart';
import 'package:inno_entry/src/core/error_handler/error_handler.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/account.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_params.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';

import '../../domain/repo/auth_repo.dart';
import '../datasources/interface/auth_datasources.dart';

class AuthRepoImpl with ErrorHandler implements AuthRepo {
  final AuthLocalDatasource authLocalDatasource;
  AuthRepoImpl({required this.authLocalDatasource});

  @override
  AsyncRequest<List<Account>> accounts() async {
    return await asyncTryCatch(
      tryFunc: () async {
        final accounts = await authLocalDatasource.getAccounts();
        return SuccessRepoCall(data: accounts);
      },
    );
  }

  @override
  AsyncRequest<AuthStatus> createAccount({required AuthParams params}) {
    return asyncTryCatch(
      tryFunc: () async {
        final status = await authLocalDatasource.saveNewAuth(params: params);
        return SuccessRepoCall(data: status);
      },
    );
  }

  @override
  AsyncRequest<AuthStatus> deleteCurrentAccount() {
    return asyncTryCatch(
      tryFunc: () async {
        final status = await authLocalDatasource.deleteCurrentAccount();
        return SuccessRepoCall(data: status);
      },
    );
  }

  @override
  AsyncRequest<bool> isAccountNameAvailable(String accountName) {
    return asyncTryCatch(
      tryFunc: () async {
        final isAvailable = await authLocalDatasource.isAccountNameAvailable(
          accountName,
        );
        return SuccessRepoCall(data: isAvailable);
      },
    );
  }

  @override
  AsyncRequest<AuthStatus> loginWithExistingAccount({
    required Account account,
  }) {
    return asyncTryCatch(
      tryFunc: () async {
        final status = await authLocalDatasource.switchAccount(
          accountName: account.uniqueName,
        );
        return SuccessRepoCall(data: status);
      },
    );
  }

  @override
  AsyncRequest<AuthStatus> logout() {
    return asyncTryCatch(
      tryFunc: () async {
        final status = await authLocalDatasource.logout();
        return SuccessRepoCall(data: status);
      },
    );
  }

  @override
  AsyncRequest<AuthStatus> unlockAccount({required AuthParams params}) {
    return asyncTryCatch(
      tryFunc: () async {
        final status = await authLocalDatasource.unlockAccount(params: params);
        return SuccessRepoCall(data: status);
      },
    );
  }

  @override
  Stream<AuthStatus> watchAuthStatus() {
    return authLocalDatasource.authStream;
  }
}
