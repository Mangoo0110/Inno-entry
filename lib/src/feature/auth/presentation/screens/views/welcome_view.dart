import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_icon.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_page_frame.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/primary_action_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key, required this.state});

  final AuthUiState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return AuthPageFrame(
      key: const ValueKey(AuthView.welcome),
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
          isProcessing: state.isSubmitting,
          onPressed: () {
            context.read<AuthBloc>().add(const AuthLoginSelected());
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: OutlinedButton(
            onPressed: state.isSubmitting
                ? null
                : () {
                    context.read<AuthBloc>().add(
                      const AuthCreateAccountSelected(),
                    );
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
