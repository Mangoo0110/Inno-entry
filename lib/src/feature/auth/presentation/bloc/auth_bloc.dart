import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/usecases/base_usecase.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/account.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_params.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_form_params.dart';
part 'auth_ui_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthUiState> {
  AuthBloc({
    required WatchAuthStatus watchAuthStatus,
    required GetAccounts getAccounts,
    required IsAccountNameAvailable isAccountNameAvailable,
    required CreateAccount createAccount,
    required UnlockAccount unlockAccount,
    required Logout logout,
  }) : _watchAuthStatus = watchAuthStatus,
       _getAccounts = getAccounts,
       _isAccountNameAvailable = isAccountNameAvailable,
       _createAccount = createAccount,
       _unlockAccount = unlockAccount,
       _logout = logout,
       super(AuthUiState.initial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSelected>(_onLoginSelected);
    on<AuthCreateAccountSelected>(_onCreateAccountSelected);
    on<AuthBackPressed>(_onBackPressed);
    on<AuthNameSubmitted>(_onNameSubmitted);
    on<AuthCreateAccountSubmitted>(_onCreateAccountSubmitted);
    on<AuthPinDigitPressed>(_onPinDigitPressed);
    on<AuthPinBackspacePressed>(_onPinBackspacePressed);
    on<AuthUnlockSubmitted>(_onUnlockSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<_AuthStatusChanged>(_onAuthStatusChanged);
  }

  final WatchAuthStatus _watchAuthStatus;
  final GetAccounts _getAccounts;
  final IsAccountNameAvailable _isAccountNameAvailable;
  final CreateAccount _createAccount;
  final UnlockAccount _unlockAccount;
  final Logout _logout;

  StreamSubscription<AuthStatus>? _authStatusSubscription;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthUiState> emit) async {
    await _authStatusSubscription?.cancel();
    _authStatusSubscription = _watchAuthStatus(
      const NoParams(),
    ).listen((status) => add(_AuthStatusChanged(status)));
    await _refreshAccounts(emit);
  }

  void _onLoginSelected(AuthLoginSelected event, Emitter<AuthUiState> emit) {
    emit(
      state.copyWith(
        view: AuthView.loginName,
        pin: '',
        clearError: true,
        clearSelectedAccountName: true,
      ),
    );
  }

  void _onCreateAccountSelected(
    AuthCreateAccountSelected event,
    Emitter<AuthUiState> emit,
  ) {
    emit(
      state.copyWith(
        view: AuthView.createAccount,
        pin: '',
        clearError: true,
        clearSelectedAccountName: true,
      ),
    );
  }

  void _onBackPressed(AuthBackPressed event, Emitter<AuthUiState> emit) {
    if (state.view == AuthView.pinUnlock) {
      emit(
        state.copyWith(
          view: AuthView.loginName,
          pin: '',
          clearError: true,
          clearSelectedAccountName: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        view: AuthView.welcome,
        pin: '',
        clearError: true,
        clearSelectedAccountName: true,
      ),
    );
  }

  Future<void> _onNameSubmitted(
    AuthNameSubmitted event,
    Emitter<AuthUiState> emit,
  ) async {
    final accountName = event.accountName.trim();
    if (accountName.isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter the account name.'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));
    final response = await _isAccountNameAvailable(accountName);
    if (!response.success || response.data == null) {
      emit(state.copyWith(isSubmitting: false, errorMessage: response.message));
      return;
    }

    if (response.data!) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'User not found. Check the name and try again.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        view: AuthView.pinUnlock,
        selectedAccountName: accountName,
        pin: '',
        isSubmitting: false,
        clearError: true,
      ),
    );
  }

  Future<void> _onCreateAccountSubmitted(
    AuthCreateAccountSubmitted event,
    Emitter<AuthUiState> emit,
  ) async {
    final accountName = event.accountName.trim();
    final pin = event.pin.trim();

    if (accountName.isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter the account name.'));
      return;
    }

    if (!_isValidPin(pin)) {
      emit(
        state.copyWith(
          errorMessage: 'PIN must be 4 to 6 digits using numbers 1 to 6.',
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));
    final availability = await _isAccountNameAvailable(accountName);
    if (!availability.success || availability.data == null) {
      emit(
        state.copyWith(isSubmitting: false, errorMessage: availability.message),
      );
      return;
    }

    if (!availability.data!) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'This account name is already registered.',
        ),
      );
      return;
    }

    final response = await _createAccount(
      _AuthFormParams(accountName: accountName, pin: pin),
    );
    if (!response.success || response.data == null) {
      emit(state.copyWith(isSubmitting: false, errorMessage: response.message));
      return;
    }

    await _refreshAccounts(emit);
    _applyAuthStatus(response.data!, emit);
  }

  void _onPinDigitPressed(
    AuthPinDigitPressed event,
    Emitter<AuthUiState> emit,
  ) {
    if (state.pin.length >= 6 || state.isSubmitting) return;
    if (!_isAllowedPinDigit(event.digit)) return;
    emit(state.copyWith(pin: '${state.pin}${event.digit}', clearError: true));
  }

  void _onPinBackspacePressed(
    AuthPinBackspacePressed event,
    Emitter<AuthUiState> emit,
  ) {
    if (state.pin.isEmpty || state.isSubmitting) return;
    emit(
      state.copyWith(
        pin: state.pin.substring(0, state.pin.length - 1),
        clearError: true,
      ),
    );
  }

  Future<void> _onUnlockSubmitted(
    AuthUnlockSubmitted event,
    Emitter<AuthUiState> emit,
  ) async {
    final accountName = state.selectedAccountName;
    if (accountName == null) {
      emit(state.copyWith(errorMessage: 'Need to have an account name.'));
      return;
    }

    if (!_isValidPin(state.pin)) {
      emit(
        state.copyWith(
          errorMessage: 'PIN must be 4 to 6 digits using numbers 1 to 6.',
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));
    final response = await _unlockAccount(
      _AuthFormParams(accountName: accountName, pin: state.pin),
    );
    if (!response.success || response.data == null) {
      emit(
        state.copyWith(
          isSubmitting: false,
          pin: '',
          errorMessage: 'PIN did not match. Try again.',
        ),
      );
      return;
    }

    _applyAuthStatus(response.data!, emit);
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthUiState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final response = await _logout(const NoParams());
    if (!response.success || response.data == null) {
      emit(state.copyWith(isSubmitting: false, errorMessage: response.message));
      return;
    }

    _applyAuthStatus(response.data!, emit);
  }

  Future<void> _onAuthStatusChanged(
    _AuthStatusChanged event,
    Emitter<AuthUiState> emit,
  ) async {
    if (event.status is Authenticated || event.status is UnAuthenticated) {
      await _refreshAccounts(emit);
    }
    _applyAuthStatus(event.status, emit);
  }

  Future<void> _refreshAccounts(Emitter<AuthUiState> emit) async {
    final response = await _getAccounts(const NoParams());
    if (!response.success) {
      emit(
        state.copyWith(
          isBootstrapping: false,
          isSubmitting: false,
          errorMessage: response.message,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        accounts: List<Account>.unmodifiable(response.data ?? const []),
        isBootstrapping: false,
      ),
    );
  }

  void _applyAuthStatus(AuthStatus status, Emitter<AuthUiState> emit) {
    switch (status) {
      case LoadingAuthSignature():
        emit(state.copyWith(isBootstrapping: true, clearError: true));
      case Authenticated(:final account):
        emit(
          state.copyWith(
            view: AuthView.signedIn,
            currentAccountName: account.uniqueName,
            selectedAccountName: account.uniqueName,
            pin: '',
            isBootstrapping: false,
            isSubmitting: false,
            clearError: true,
          ),
        );
      case UnAuthenticated():
        emit(
          state.copyWith(
            view: AuthView.welcome,
            pin: '',
            isBootstrapping: false,
            isSubmitting: false,
            clearError: true,
            clearCurrentAccountName: true,
            clearSelectedAccountName: true,
          ),
        );
    }
  }

  bool _isValidPin(String pin) {
    if (pin.length < 4 || pin.length > 6) return false;
    return pin.split('').every(_isAllowedPinDigit);
  }

  bool _isAllowedPinDigit(String digit) {
    return digit.length == 1 &&
        digit.codeUnitAt(0) >= 49 &&
        digit.codeUnitAt(0) <= 54;
  }

  @override
  Future<void> close() async {
    await _authStatusSubscription?.cancel();
    return super.close();
  }
}
