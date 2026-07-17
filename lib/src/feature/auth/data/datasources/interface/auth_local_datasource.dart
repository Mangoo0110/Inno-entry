import 'package:inno_entry/src/feature/auth/data/models/account_model.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_params.dart';

abstract interface class AuthLocalDatasource {
  Future<void> init();

  void dispose();

  Stream<AuthStatus> get authStream;

  Future<AuthStatus> currentAuthStatus();

  Future<AccountModel?> getCurrentAccount();

  Future<List<AccountModel>> getAccounts();

  Future<bool> isAccountNameAvailable(String accountName);

  Future<AuthStatus> saveNewAuth({required AuthParams params});

  Future<AuthStatus> changePin({required AuthParams params});

  Future<AuthStatus> unlockAccount({required AuthParams params});

  Future<AuthStatus> switchAccount({required String accountName});

  Future<AuthStatus> logout();

  Future<AuthStatus> deleteCurrentAccount();

  Future<AuthStatus> deleteAllAccounts();
}
