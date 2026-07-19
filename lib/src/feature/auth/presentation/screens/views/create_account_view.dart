import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_icon.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_page_frame.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/primary_action_button.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key, required this.state});

  final AuthUiState state;

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  String? _pinErrorText;

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final state = widget.state;

    return AuthPageFrame(
      key: const ValueKey(AuthView.createAccount),
      headerTitle: 'Create account',
      bottomChild: Text(
        "Your accounnt always lives on your device. It's secured and never shared.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colors.grey,
          height: 1.4,
          overflow: TextOverflow.visible,
        ),
      ),
      children: [
        const AuthIcon(
          icon: Icons.person_add_alt_1_rounded,
          noBackground: true,
        ),
        const SizedBox(height: 8),
        Text(
          'Create your account',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.visible,
          ),
        ),
        const SizedBox(height: 36),
        SizedBox(
          height: 70,
          child: TextField(
            controller: _nameController,
            expands: true,
            maxLines: null,
            enabled: !state.isSubmitting,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Rahul Sharma',
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: _pinErrorText == null ? 78 : 94,
          child: TextField(
            controller: _pinController,
            maxLines: 1,
            enabled: !state.isSubmitting,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            obscureText: true,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: 'PIN (4-6 digits)',
              helperText: 'Use numbers 1 to 6 only',
              errorText: _pinErrorText,
              counterText: '',
            ),
            onChanged: _onPinChanged,
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(height: 20),
        PrimaryActionButton(
          label: 'Create account',
          isProcessing: state.isSubmitting,
          onPressed: _submit,
        ),
      ],
    );
  }

  void _submit() {
    final pin = _pinController.text.trim();
    final pinError = _pinErrorFor(pin, validateLength: true);
    if (pinError != null) {
      setState(() => _pinErrorText = pinError);
      return;
    }

    context.read<AuthBloc>().add(
      AuthCreateAccountSubmitted(accountName: _nameController.text, pin: pin),
    );
  }

  void _onPinChanged(String value) {
    final pinError = _pinErrorFor(value, validateLength: false);
    if (pinError == _pinErrorText) return;
    setState(() => _pinErrorText = pinError);
  }

  String? _pinErrorFor(String value, {required bool validateLength}) {
    if (value.contains(RegExp(r'[^1-6]'))) {
      return 'Use numbers 1 to 6 only.';
    }

    if (!validateLength) return null;
    if (value.length < 4) return 'PIN must be at least 4 digits.';
    if (value.length > 6) return 'PIN can be up to 6 digits.';
    return null;
  }
}
