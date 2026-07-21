import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app/bloc/app_theme_cubit.dart';
import 'src/app/bloc/auth_guard/app_auth_guard_bloc.dart';
import 'src/di/service_locator.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _authGuardBloc = serviceLocator<AppAuthGuardBloc>();
  static final _appTheme = AppTheme();
  static final _router = createAppRouter(authGuardBloc: _authGuardBloc);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authGuardBloc),
        BlocProvider.value(value: serviceLocator<AppThemeCubit>()),
      ],
      child: BlocBuilder<AppThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Daily expenses record app.',
            debugShowCheckedModeBanner: false,
            theme: _appTheme.lightTheme,
            darkTheme: _appTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
