import 'package:flutter/material.dart';

import 'src/core/routing/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/feature/auth/data/datasources/auth_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authStorage = AuthStorage();
  await authStorage.init();
  runApp(MyApp(authStorage: authStorage));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.authStorage});

  final AuthStorage? authStorage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = createAppRouter(authStorage: authStorage!);

    return MaterialApp.router(
      title: 'Daily expenses record app.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
