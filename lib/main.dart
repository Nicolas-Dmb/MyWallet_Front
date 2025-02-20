import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'core/routing/app_router.dart';
import '../core/theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(MyApp()));
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
