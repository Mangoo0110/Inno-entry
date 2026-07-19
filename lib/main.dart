import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app/bloc/app_auth_ui_controller.dart';
import 'src/app/bloc/app_theme_cubit.dart';
import 'src/core/di/service_locator.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';

// final navigationKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _authController = serviceLocator<AppAuthUiController>();
  static final _appTheme = AppTheme();
  static final _router = createAppRouter(authController: _authController);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authController),
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
