import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/service/auth_session_service.dart';
import 'package:mywallet_mobile/core/widgets/navigation_bar/main_screen.dart';
import 'package:mywallet_mobile/core/widgets/pages/not_found_widget.dart';
import 'package:mywallet_mobile/core/widgets/pages/splash_screen.dart';
import 'package:mywallet_mobile/features/authentification/auth_barrel.dart';
import 'package:mywallet_mobile/features/dashboard/dashboard_screen.dart';
import 'package:mywallet_mobile/features/documentation/documentation_screen.dart';
import 'package:mywallet_mobile/features/settings/Settings_screen.dart';
import 'package:mywallet_mobile/features/trading/presentation/trading_quizz_widget.dart';
import 'package:mywallet_mobile/features/trading/presentation/trading_widget.dart';
import 'package:mywallet_mobile/features/welcome/presentation/welcome_widget.dart';

class AppRouter {
  static String lastKnownRoute = "/welcome";

  static GoRouter router() {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          pageBuilder: (context, state) {
            lastKnownRoute = '/splash';
            return Transition.getAnimation(state, context, SplashScreen());
          },
        ),
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
        ShellRoute(
          redirect: (context, state) async {
            final isLoggedIn = await di<AuthService>().isLoggedIn();
            if (!isLoggedIn) {
              return '/login';
            }
            return null;
          },
          builder: (context, state, child) {
            return MainScreen(location: state.uri.toString(), child: child);
          },
          routes: [
            GoRoute(
              path: '/dashboard',
              pageBuilder: (context, state) {
                lastKnownRoute = '/dashboard';
                return Transition.getAnimation(
                  state,
                  context,
                  DashboardScreen(),
                );
              },
            ),
            GoRoute(
              path: '/dashboard',
              pageBuilder: (context, state) {
                lastKnownRoute = '/dashboard';
                return Transition.getAnimation(
                  state,
                  context,
                  DashboardScreen(),
                );
              },
              routes: [
                GoRoute(
                  path: '/trading',
                  pageBuilder: (context, state) {
                    lastKnownRoute = '/dashboard/trading';
                    return Transition.getAnimation(
                      state,
                      context,
                      TradingWidget(),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: '/quizz',
                      pageBuilder: (context, state) {
                        lastKnownRoute = '/dashboard/trading/quizz';
                        return Transition.getAnimation(
                          state,
                          context,
                          TradingQuizzWidget(isBuy: state.extra! as bool),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) {
                lastKnownRoute = '/settings';
                return Transition.getAnimation(
                  state,
                  context,
                  SettingsScreen(),
                );
              },
            ),
            GoRoute(
              path: '/documentation',
              pageBuilder: (context, state) {
                lastKnownRoute = '/documentation';
                return Transition.getAnimation(
                  state,
                  context,
                  DocumentationScreen(),
                );
              },
            ),
          ],
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
