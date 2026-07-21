import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_form_params.dart';

part 'login_event.dart';
part 'login_state.dart';

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required IsAccountNameAvailable isAccountNameAvailable,
    required UnlockAccount unlockAccount,
  }) : _isAccountNameAvailable = isAccountNameAvailable,
       _unlockAccount = unlockAccount,
       super(LoginState.initial()) {
    on<LoginReset>(_onReset);
    on<LoginNameSubmitted>(_onNameSubmitted);
    on<LoginPinDigitPressed>(_onPinDigitPressed);
    on<LoginPinBackspacePressed>(_onPinBackspacePressed);
    on<LoginUnlockSubmitted>(_onUnlockSubmitted);
  }

  final IsAccountNameAvailable _isAccountNameAvailable;
  final UnlockAccount _unlockAccount;

  void _onReset(LoginReset event, Emitter<LoginState> emit) {
    emit(LoginState.initial());
  }

  Future<void> _onNameSubmitted(
    LoginNameSubmitted event,
    Emitter<LoginState> emit,
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
        selectedAccountName: accountName,
        pin: '',
        isSubmitting: false,
        clearError: true,
      ),
    );
  }

  void _onPinDigitPressed(
    LoginPinDigitPressed event,
    Emitter<LoginState> emit,
  ) {
    if (state.pin.length >= 6 || state.isSubmitting) return;
    if (!_isAllowedPinDigit(event.digit)) return;
    emit(state.copyWith(pin: '${state.pin}${event.digit}', clearError: true));
  }

  void _onPinBackspacePressed(
    LoginPinBackspacePressed event,
    Emitter<LoginState> emit,
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
    LoginUnlockSubmitted event,
    Emitter<LoginState> emit,
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
      AuthFormParams(accountName: accountName, pin: state.pin),
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

    emit(state.copyWith(isSubmitting: false, clearError: true));
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
}
