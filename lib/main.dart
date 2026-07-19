import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app/bloc/app_auth_ui_controller.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AppAuthUiController>(),
      child: MaterialApp.router(
        title: 'Daily expenses record app.',
        debugShowCheckedModeBanner: false,

        theme: AppTheme().lightTheme,
        darkTheme: AppTheme().darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: createAppRouter(),
      ),
    );
  }
}
