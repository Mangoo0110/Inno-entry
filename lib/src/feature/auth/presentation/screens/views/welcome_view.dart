import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inno_entry/src/core/routing/app_routes.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/login/login_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/register/register_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_icon.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_page_frame.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/primary_action_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return AuthPageFrame(
      key: const ValueKey(AppRoutes.auth),
      topSpacing: 110,
      children: [
        const AuthIcon(icon: Icons.edit_note_rounded),
        const SizedBox(height: 28),
        Text(
          'InnoEntry',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.visible,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            'Notes, tasks, and expenses - all on this device.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.grey,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        const SizedBox(height: 50),
        PrimaryActionButton(
          label: 'Log in',
          isProcessing: false,
          onPressed: () {
            context.read<LoginBloc>().add(const LoginReset());
            context.go(AppRoutes.authLogin);
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: OutlinedButton(
            onPressed: () {
              context.read<RegisterBloc>().add(const RegisterReset());
              context.go(AppRoutes.authRegister);
            },
            child: const Text('Sign up'),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 14, color: colors.grey),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Everything stays on your phone',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.grey,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
