import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/widgets/pages/not_found_widget.dart';
import 'package:mywallet_mobile/login/presentation/login_widget.dart';
import 'package:mywallet_mobile/welcome/presentation/welcome_widget.dart';

class AppRouter {
  static String lastKnownRoute = "/welcome";
  static final GoRouter router = GoRouter(
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
    ],
    errorBuilder: (context, state) {
      return NotFoundScreen(previousRoute: lastKnownRoute);
    },
  );
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
