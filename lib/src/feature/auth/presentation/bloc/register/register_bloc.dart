import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_form_params.dart';

part 'register_event.dart';
part 'register_state.dart';

final class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required IsAccountNameAvailable isAccountNameAvailable,
    required CreateAccount createAccount,
  }) : _isAccountNameAvailable = isAccountNameAvailable,
       _createAccount = createAccount,
       super(RegisterState.initial()) {
    on<RegisterReset>(_onReset);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final IsAccountNameAvailable _isAccountNameAvailable;
  final CreateAccount _createAccount;

  void _onReset(RegisterReset event, Emitter<RegisterState> emit) {
    emit(RegisterState.initial());
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
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
      AuthFormParams(accountName: accountName, pin: pin),
    );
    if (!response.success || response.data == null) {
      emit(state.copyWith(isSubmitting: false, errorMessage: response.message));
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
