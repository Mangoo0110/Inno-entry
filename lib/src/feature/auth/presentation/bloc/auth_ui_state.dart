part of 'auth_bloc.dart';

enum AuthView { welcome, loginName, pinUnlock, createAccount, signedIn }

final class AuthUiState {
  const AuthUiState({
    required this.view,
    required this.accounts,
    this.selectedAccountName,
    this.currentAccountName,
    this.pin = '',
    this.isBootstrapping = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  factory AuthUiState.initial() {
    return const AuthUiState(
      view: AuthView.welcome,
      accounts: [],
      isBootstrapping: true,
    );
  }

  final AuthView view;
  final List<Account> accounts;
  final String? selectedAccountName;
  final String? currentAccountName;
  final String pin;
  final bool isBootstrapping;
  final bool isSubmitting;
  final String? errorMessage;

  bool get canUnlock => selectedAccountName != null && pin.length >= 4;

  AuthUiState copyWith({
    AuthView? view,
    List<Account>? accounts,
    String? selectedAccountName,
    String? currentAccountName,
    String? pin,
    bool? isBootstrapping,
    bool? isSubmitting,
    String? errorMessage,
    bool clearSelectedAccountName = false,
    bool clearCurrentAccountName = false,
    bool clearError = false,
  }) {
    return AuthUiState(
      view: view ?? this.view,
      accounts: accounts ?? this.accounts,
      selectedAccountName: clearSelectedAccountName
          ? null
          : selectedAccountName ?? this.selectedAccountName,
      currentAccountName: clearCurrentAccountName
          ? null
          : currentAccountName ?? this.currentAccountName,
      pin: pin ?? this.pin,
      isBootstrapping: isBootstrapping ?? this.isBootstrapping,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
