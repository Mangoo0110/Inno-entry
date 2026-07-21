import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app/bloc/app_theme_cubit.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/di/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.create();
  runApp(MyApp(dependencies: dependencies));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.dependencies});

  final AppDependencies dependencies;
  final _appTheme = AppTheme();
  late final _router = createAppRouter(
    authGuardBloc: dependencies.authGuardBloc,
  );

  @override
  Widget build(BuildContext context) {
    return AppDependencyScope(
      dependencies: dependencies,
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
