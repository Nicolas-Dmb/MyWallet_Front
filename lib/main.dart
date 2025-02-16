import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import '../core/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wallet',
      routerConfig: AppRouter.router,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.background1),
    );
  }
}
