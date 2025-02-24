import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<GoRouter>(() => AppRouter.router);
  locator.registerLazySingleton<AppLogger>(() => AppLogger());
}
