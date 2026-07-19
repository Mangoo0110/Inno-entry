import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inno_entry/src/app/bloc/app_auth_ui_controller.dart';
import 'package:inno_entry/src/app/view/app_splash_view.dart';
import 'package:inno_entry/src/core/routing/app_routes.dart';
import 'package:inno_entry/src/feature/auth/domain/entities/auth_status.dart';

enum AuthRoutePolicy { guestOnly, signedInOnly }

class AuthRouteGate extends StatefulWidget {
  const AuthRouteGate({super.key, required this.policy, required this.child});

  final AuthRoutePolicy policy;
  final Widget child;

  @override
  State<AuthRouteGate> createState() => _AuthRouteGateState();
}

class _AuthRouteGateState extends State<AuthRouteGate> {
  String? _pendingLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleNavigation(context.read<AppAuthUiController>().state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppAuthUiController, AuthStatus>(
      listenWhen: _shouldListen,
      listener: (context, state) => _scheduleNavigation(state),
      buildWhen: _shouldBuildGate,
      builder: (context, state) {
        if (state is LoadingAuthSignature) return const AppSplashView();
        return widget.child;
      },
    );
  }

  bool _shouldListen(AuthStatus previous, AuthStatus current) {
    if (previous.runtimeType != current.runtimeType) return true;
    if (previous is Authenticated && current is Authenticated) {
      return previous.account.uniqueName != current.account.uniqueName;
    }
    return false;
  }

  bool _shouldBuildGate(AuthStatus previous, AuthStatus current) {
    return previous is LoadingAuthSignature || current is LoadingAuthSignature;
  }

  void _scheduleNavigation(AuthStatus state) {
    final location = switch ((widget.policy, state)) {
      (AuthRoutePolicy.guestOnly, Authenticated()) => AppRoutes.entryFeed,
      (AuthRoutePolicy.signedInOnly, UnAuthenticated()) => AppRoutes.auth,
      _ => null,
    };

    if (location == null || _pendingLocation == location) return;
    _pendingLocation = location;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final currentLocation = GoRouterState.of(context).uri.path;
      if (currentLocation != location) context.go(location);
      _pendingLocation = null;
    });
  }
}

class AuthenticatedAccountRoute extends StatelessWidget {
  const AuthenticatedAccountRoute({super.key, required this.builder});

  final Widget Function(BuildContext context, String accountName) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAuthUiController, AuthStatus>(
      buildWhen: _shouldBuild,
      builder: (context, state) {
        if (state is! Authenticated) {
          return const AppSplashView();
        }

        return builder(context, state.account.uniqueName);
      },
    );
  }

  bool _shouldBuild(AuthStatus previous, AuthStatus current) {
    if (previous.runtimeType != current.runtimeType) return true;
    if (previous is Authenticated && current is Authenticated) {
      return previous.account.uniqueName != current.account.uniqueName;
    }
    return false;
  }
}
