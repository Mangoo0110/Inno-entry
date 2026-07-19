import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inno_entry/src/app/bloc/app_auth_ui_controller.dart';
import 'package:inno_entry/src/core/di/service_locator.dart';
import 'package:inno_entry/src/core/routing/app_routes.dart';
import 'package:inno_entry/src/core/routing/auth_route_gate.dart';
import 'package:inno_entry/src/feature/auth/presentation/screens/auth_screen.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_feed_bloc.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_dashboard/user_dashboard_view.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/entry_detail_result.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/entry_detail_screen.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/entry_form_screen.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/entry_form_view.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.auth,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: AuthRouteGate(
              policy: AuthRoutePolicy.guestOnly,
              child: const AuthScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.entryFeed,
        name: 'entry-feed',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: AuthRouteGate(
              policy: AuthRoutePolicy.signedInOnly,
              child: AuthenticatedAccountRoute(
                builder: (context, accountName) {
                  return UserDashboardView(
                    accountName: accountName,
                    createBloc: (accountName) =>
                        serviceLocator<EntryFeedBloc>(param1: accountName),
                    onAddEntryPressed: () {
                      return context.push<bool>(AppRoutes.entryForm);
                    },
                    onEntryPressed: (entry) {
                      return context.push<EntryDetailResult>(
                        '${AppRoutes.entryDetail}?entryId=${entry.uId.uId}',
                      );
                    },
                    onLogoutPressed: () {
                      return context.read<AppAuthUiController>().logout();
                    },
                    onDeleteAccountPressed: () {
                      return context
                          .read<AppAuthUiController>()
                          .deleteCurrentAccount();
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.entryDetail,
        name: 'entry-detail',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: AuthRouteGate(
              policy: AuthRoutePolicy.signedInOnly,
              child: AuthenticatedAccountRoute(
                builder: (context, accountName) {
                  final entryId = int.tryParse(
                    state.uri.queryParameters['entryId'] ?? '',
                  );
                  if (entryId == null) return const SizedBox.shrink();
                  return EntryDetailScreen(
                    accountName: accountName,
                    entryId: entryId,
                  );
                },
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.entryForm,
        name: 'entry-form',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: AuthRouteGate(
              policy: AuthRoutePolicy.signedInOnly,
              child: AuthenticatedAccountRoute(
                builder: (context, accountName) {
                  final entryId = int.tryParse(
                    state.uri.queryParameters['entryId'] ?? '',
                  );
                  return EntryFormScreen(
                    accountName: accountName,
                    mode: entryId == null
                        ? EntryFormMode.create
                        : EntryFormMode.edit,
                    entryId: entryId,
                  );
                },
              ),
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      return const SizedBox.shrink();
    },
  );
}
