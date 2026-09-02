part of 'login_bloc.dart';

final class LoginState {
  const LoginState({
    this.selectedAccountName,
    this.pin = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  factory LoginState.initial() {
    return const LoginState();
  }

  final String? selectedAccountName;
  final String pin;
  final bool isSubmitting;
  final String? errorMessage;

  bool get canUnlock => selectedAccountName != null && pin.length >= 4;

  LoginState copyWith({
    String? selectedAccountName,
    String? pin,
    bool? isSubmitting,
    String? errorMessage,
    bool clearSelectedAccountName = false,
    bool clearError = false,
  }) {
    return LoginState(
      selectedAccountName: clearSelectedAccountName
          ? null
          : selectedAccountName ?? this.selectedAccountName,
      pin: pin ?? this.pin,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
