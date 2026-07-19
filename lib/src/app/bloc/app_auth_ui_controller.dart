import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_all_entry.dart';
import 'package:inno_entry/src/feature/entry/domain/usecases/delete_all_entry.dart';

final class AppAuthUiController extends Cubit<AuthStatus> {
  AppAuthUiController({
    required WatchAuthStatus watchAuthStatus,
    required Logout logout,
    required DeleteCurrentAccount deleteCurrentAccount,
    required DeleteAllEntry deleteAllEntry,
  }) : _watchAuthStatus = watchAuthStatus,
       _logout = logout,
       _deleteCurrentAccount = deleteCurrentAccount,
       _deleteAllEntry = deleteAllEntry,
       super(LoadingAuthSignature()) {
    _watchAuthStatusChanges();
  }

  StreamSubscription<AuthStatus>? _authStatusSubscription;
  final WatchAuthStatus _watchAuthStatus;
  final Logout _logout;
  final DeleteCurrentAccount _deleteCurrentAccount;
  final DeleteAllEntry _deleteAllEntry;

  Future<void> logout() async {
    await _logout(const NoParams());
  }

  Future<bool> deleteCurrentAccount() async {
    final authStatus = state;
    if (authStatus is! Authenticated) return false;

    final entriesResponse = await _deleteAllEntry(
      DeleteAllEntryParam(owner: authStatus.account.uniqueName),
    );
    if (!entriesResponse.success) return false;

    final accountResponse = await _deleteCurrentAccount(const NoParams());
    return accountResponse.success;
  }

  void _watchAuthStatusChanges() {
    _authStatusSubscription = _watchAuthStatus(const NoParams()).listen(emit);
  }

  @override
  Future<void> close() async {
    await _authStatusSubscription?.cancel();
    return super.close();
  }
}
