import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/routing/app_router.dart';
import 'package:mywallet_mobile/features/authentification/presentation/login_widget.dart';
import 'package:mywallet_mobile/features/welcome/presentation/welcome_widget.dart';
import 'package:mywallet_mobile/core/widgets/pages/not_found_widget.dart';

void main() {
  Widget testableApp(GoRouter router) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp.router(routerConfig: router),
    );
  }

  // testWidgets("Should be at welcome in first page", (
  //   WidgetTester tester,
  // ) async {
  //   final router = AppRouter.router();
  //   await tester.pumpWidget(testableApp(router));
  //   await tester.pumpAndSettle();
  //   expect(find.byType(Welcome), findsOneWidget);
  // });

  // testWidgets("Should navigate to login", (tester) async {
  //   final router = AppRouter.router();
  //   await tester.pumpWidget(testableApp(router));
  //   await tester.pumpAndSettle();

  //   router.go('/login');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(Login), findsOneWidget);
  // });

  // testWidgets("Should navigate in not_found page after bad url", (
  //   WidgetTester tester,
  // ) async {
  //   final router = AppRouter.router();
  //   await tester.pumpWidget(testableApp(router));
  //   await tester.pumpAndSettle();

  //   router.go('/unknown_page');
  //   await tester.pumpAndSettle();

  //   expect(find.byType(NotFoundScreen), findsOneWidget);
  // });
}
