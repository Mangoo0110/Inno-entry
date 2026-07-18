import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:inno_entry/src/feature/auth/data/datasources/auth_storage.dart';
import 'package:inno_entry/src/feature/auth/presentation/auth_feature.dart';

class AppRoutes {
  const AppRoutes._();

  static const auth = '/auth';
}

GoRouter createAppRouter({required AuthStorage authStorage}) {
  return GoRouter(
    initialLocation: AppRoutes.auth,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: AuthFeature(authStorage: authStorage),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      return const SizedBox.shrink();
    },
  );
}
