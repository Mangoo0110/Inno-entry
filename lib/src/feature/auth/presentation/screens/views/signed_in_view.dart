import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_icon.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_page_frame.dart';

class SignedInView extends StatelessWidget {
  const SignedInView({super.key, required this.state});

  final AuthUiState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final accountName = state.currentAccountName ?? 'InnoEntry';

    return AuthPageFrame(
      key: const ValueKey(AuthView.signedIn),
      topSpacing: 120,
      children: [
        const AuthIcon(icon: Icons.check_rounded),
        const SizedBox(height: 28),
        Text(
          'InnoEntry',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.visible,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          accountName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.grey,
            overflow: TextOverflow.visible,
          ),
        ),
        const SizedBox(height: 80),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: OutlinedButton.icon(
            onPressed: state.isSubmitting
                ? null
                : () {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
          ),
        ),
      ],
    );
  }
}
