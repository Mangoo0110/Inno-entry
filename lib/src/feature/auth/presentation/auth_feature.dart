import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/auth_storage.dart';
import 'package:inno_entry/src/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:inno_entry/src/feature/auth/domain/usecases/auth_usecases.dart';
import 'package:inno_entry/src/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inno_entry/src/feature/auth/presentation/screens/auth_screen.dart';

class AuthFeature extends StatelessWidget {
  const AuthFeature({super.key, required this.authStorage});

  final AuthStorage authStorage;

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepoImpl(authLocalDatasource: authStorage);

    return BlocProvider(
      create: (_) =>
          AuthBloc(
              watchAuthStatus: WatchAuthStatus(authRepo),
              getAccounts: GetAccounts(authRepo),
              isAccountNameAvailable: IsAccountNameAvailable(authRepo),
              createAccount: CreateAccount(authRepo),
              unlockAccount: UnlockAccount(authRepo),
              logout: Logout(authRepo),
            )
            // Initiate with AuthStarted
            ..add(const AuthStarted()),
      child: const AuthScreen(),
    );
  }
}
