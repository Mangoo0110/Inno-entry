import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/screens/views/create_account_view.dart';
import 'package:inno_entry/src/feature/auth/presentation/screens/views/login_name_view.dart';
import 'package:inno_entry/src/feature/auth/presentation/screens/views/pin_unlock_view.dart';
import 'package:inno_entry/src/feature/auth/presentation/screens/views/signed_in_view.dart';
import 'package:inno_entry/src/feature/auth/presentation/screens/views/welcome_view.dart';

import 'package:inno_entry/src/feature/auth/presentation/widgets/error_notice.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Scaffold(
      backgroundColor: colors.appBackgroundColor,
      bottomNavigationBar: BlocSelector<AuthBloc, AuthUiState, String?>(
        selector: (state) => state.errorMessage,
        builder: (context, errorMessage) {
          if (errorMessage == null) return const SizedBox.shrink();

          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ErrorNotice(errorMessage),
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: BlocBuilder<AuthBloc, AuthUiState>(
              builder: (context, state) {
                if (state.isBootstrapping) {
                  return const Center(child: CircularProgressIndicator());
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _AuthViewSwitcher(state: state),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthViewSwitcher extends StatelessWidget {
  const _AuthViewSwitcher({required this.state});

  final AuthUiState state;

  @override
  Widget build(BuildContext context) {
    return switch (state.view) {
      AuthView.welcome => WelcomeView(state: state),
      AuthView.loginName => LoginNameView(state: state),
      AuthView.pinUnlock => PinUnlockView(state: state),
      AuthView.createAccount => CreateAccountView(state: state),
      AuthView.signedIn => SignedInView(state: state),
    };
  }
}
