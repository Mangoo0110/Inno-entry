import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_icon.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_page_frame.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/pin_dots.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/pin_keypad.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/primary_action_button.dart';

class PinUnlockView extends StatelessWidget {
  const PinUnlockView({super.key, required this.state});

  final AuthUiState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final accountName = state.selectedAccountName ?? '';

    return AuthPageFrame(
      key: const ValueKey(AuthView.pinUnlock),
      headerTitle: '',
      maxWidth: 292,
      topSpacing: 108,
      children: [
        const AuthIcon(
          icon: Icons.lock_outline_rounded,
          size: 72,
          iconSize: 38,
          borderRadius: 22,
        ),
        const SizedBox(height: 28),
        Text(
          'Enter PIN for\n$accountName',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.24,
            overflow: TextOverflow.visible,
          ),
        ),
        const SizedBox(height: 46),
        SizedBox(
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PinDots(pinLength: state.pin.length),
              Positioned(
                right: 0,
                child: IconButton(
                  tooltip: 'Backspace',
                  onPressed: state.pin.isEmpty || state.isSubmitting
                      ? null
                      : () {
                          context.read<AuthBloc>().add(
                            const AuthPinBackspacePressed(),
                          );
                        },
                  icon: const Icon(Icons.backspace_outlined, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Divider(height: 1, thickness: 1, color: colors.primaryColor),
        const SizedBox(height: 40),
        PrimaryActionButton(
          label: 'Unlock',
          isProcessing: state.isSubmitting,
          width: double.infinity,
          height: 60,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          onPressed: state.canUnlock
              ? () {
                  context.read<AuthBloc>().add(const AuthUnlockSubmitted());
                }
              : null,
        ),
        const SizedBox(height: 136),
        PinKeypad(isLocked: state.isSubmitting),
      ],
    );
  }
}
