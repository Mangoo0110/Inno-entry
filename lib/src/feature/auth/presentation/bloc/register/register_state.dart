part of 'register_bloc.dart';

final class RegisterState {
  const RegisterState({this.isSubmitting = false, this.errorMessage});

  factory RegisterState.initial() {
    return const RegisterState();
  }

  final bool isSubmitting;
  final String? errorMessage;

  RegisterState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RegisterState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
