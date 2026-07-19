import 'dart:async';

import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import '../../feature/auth/domain/usecases/auth_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class AppAuthUiController extends Cubit<AuthStatus> {
  AppAuthUiController({
    required WatchAuthStatus watchAuthStatus,
    required Logout logout,
  }) : _watchAuthStatus = watchAuthStatus,
       _logout = logout,
       super(LoadingAuthSignature()) {
    _watchAuthStatusChanges();
  }

  StreamSubscription<AuthStatus>? _authStatusSubscription;
  final WatchAuthStatus _watchAuthStatus;
  final Logout _logout;

  Future<void> logout() async {
    await _logout(const NoParams());
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
