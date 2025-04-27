import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/service/auth_session_service.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      final isLoggedIn = await di<AuthService>().isLoggedIn();
      if (isLoggedIn) {
        context.go('/dashboard');
      } else {
        context.go('/welcome');
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
