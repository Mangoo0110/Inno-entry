import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inno_entry/src/core/di/service_locator.dart';
import 'package:inno_entry/src/core/routing/app_routes.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/login/login_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/register/register_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/error_notice.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({
    super.key,
    required this.routePath,
    required this.child,
    this.createLoginBloc,
    this.createRegisterBloc,
  });

  final String routePath;
  final Widget child;
  final LoginBloc Function()? createLoginBloc;
  final RegisterBloc Function()? createRegisterBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => createLoginBloc?.call() ?? serviceLocator<LoginBloc>(),
        ),
        BlocProvider(
          create: (_) =>
              createRegisterBloc?.call() ?? serviceLocator<RegisterBloc>(),
        ),
      ],
      child: _AuthScreenView(routePath: routePath, child: child),
    );
  }
}

class _AuthScreenView extends StatelessWidget {
  const _AuthScreenView({required this.routePath, required this.child});

  final String routePath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.isSubmitting &&
          !current.isSubmitting &&
          current.selectedAccountName != null &&
          current.errorMessage == null,
      listener: (context, state) {
        if (routePath == AppRoutes.authLogin) {
          context.go(AppRoutes.authPin);
        }
      },
      child: Scaffold(
        backgroundColor: colors.appBackgroundColor,
        bottomNavigationBar: _AuthErrorBar(routePath: routePath),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthErrorBar extends StatelessWidget {
  const _AuthErrorBar({required this.routePath});

  final String routePath;

  @override
  Widget build(BuildContext context) {
    return switch (routePath) {
      AppRoutes.authLogin ||
      AppRoutes.authPin => BlocSelector<LoginBloc, LoginState, String?>(
        selector: (state) => state.errorMessage,
        builder: _buildErrorNotice,
      ),
      AppRoutes.authRegister =>
        BlocSelector<RegisterBloc, RegisterState, String?>(
          selector: (state) => state.errorMessage,
          builder: _buildErrorNotice,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildErrorNotice(BuildContext context, String? errorMessage) {
    if (errorMessage == null) return const SizedBox.shrink();

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ErrorNotice(errorMessage),
    );
  }
}
