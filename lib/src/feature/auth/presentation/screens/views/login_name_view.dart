import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inno_entry/src/core/routing/app_routes.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/login/login_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/register/register_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_icon.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/auth_page_frame.dart';
import 'package:inno_entry/src/feature/auth/presentation/widgets/primary_action_button.dart';

class LoginNameView extends StatefulWidget {
  const LoginNameView({super.key});

  @override
  State<LoginNameView> createState() => _LoginNameViewState();
}

class _LoginNameViewState extends State<LoginNameView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return AuthPageFrame(
          key: const ValueKey(AppRoutes.authLogin),
          headerTitle: 'Log in',
          onBackPressed: () {
            context.read<LoginBloc>().add(const LoginReset());
            context.go(AppRoutes.auth);
          },
          children: [
            const AuthIcon(
              icon: Icons.person_outline_rounded,
              noBackground: true,
            ),
            const SizedBox(height: 8),
            Text(
              'Log in',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 70,
              child: TextField(
                controller: _controller,
                onTapOutside: (event) => _focusNode.unfocus(),
                focusNode: _focusNode,
                expands: true,
                maxLines: null,
                textInputAction: TextInputAction.done,
                enabled: !state.isSubmitting,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Rahul Sharma',
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(height: 20),
            PrimaryActionButton(
              label: 'Log in',
              isProcessing: state.isSubmitting,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: state.isSubmitting
                  ? null
                  : () {
                      context.read<RegisterBloc>().add(const RegisterReset());
                      context.go(AppRoutes.authRegister);
                    },
              child: const Text('Sign up'),
            ),
          ],
        );
      },
    );
  }

  void _submit() {
    context.read<LoginBloc>().add(LoginNameSubmitted(_controller.text));
  }
}
