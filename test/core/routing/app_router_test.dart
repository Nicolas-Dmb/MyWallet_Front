import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/routing/app_router.dart';
import 'package:mywallet_mobile/features/authentification/presentation/login_widget.dart';
import 'package:mywallet_mobile/features/welcome/presentation/welcome_widget.dart';
import 'package:mywallet_mobile/core/widgets/pages/not_found_widget.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = AppRouter.router;
  });

  testWidgets("Should be at welcome in first page", (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    expect(find.byType(Welcome), findsOneWidget);
  });

  testWidgets("Should navigate in login", (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    router.go('/login');
    await tester.pumpAndSettle();

    expect(find.byType(Login), findsOneWidget);
  });

  testWidgets("Should navigate in not_found page after bad url", (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    router.go('/unknown_page');
    await tester.pumpAndSettle();

    expect(find.byType(NotFoundScreen), findsOneWidget);
  });
}
