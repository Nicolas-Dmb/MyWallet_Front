import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/login/presentation/login_widget.dart';
import 'package:mywallet_mobile/welcome/presentation/welcome_widget.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) {
          return Transition.getAnimation(state, context, Welcome());
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return Transition.getAnimation(state, context, Login());
        },
      ),
    ],
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
