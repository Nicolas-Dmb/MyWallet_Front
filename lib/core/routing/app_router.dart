import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/widgets/pages/not_found_widget.dart';
import 'package:mywallet_mobile/features/authentification/auth_barrel.dart';
import 'package:mywallet_mobile/features/welcome/presentation/welcome_widget.dart';

class AppRouter {
  static String lastKnownRoute = "/welcome";

  static GoRouter router() {
    return GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(
          path: '/welcome',
          pageBuilder: (context, state) {
            lastKnownRoute = '/welcome';
            return Transition.getAnimation(state, context, Welcome());
          },
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) {
            lastKnownRoute = '/login';
            return Transition.getAnimation(state, context, Login());
          },
        ),
        GoRoute(
          path: '/signup',
          pageBuilder: (context, state) {
            lastKnownRoute = '/signup';
            return Transition.getAnimation(state, context, Signup());
          },
        ),
      ],
      errorBuilder: (context, state) {
        return NotFoundScreen(previousRoute: lastKnownRoute, state: state);
      },
    );
  }
}

class Transition {
  static CustomTransitionPage getAnimation(
    GoRouterState state,
    BuildContext context,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    );
  }
}
