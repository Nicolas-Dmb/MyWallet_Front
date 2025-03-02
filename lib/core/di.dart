import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mywallet_mobile/core/application/newtwork_info.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mywallet_mobile/features/authentification/auth_di.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<GoRouter>(() => AppRouter.router);

  locator.registerLazySingleton(() => FlutterSecureStorage());

  locator.registerLazySingleton(() => http.Client());

  locator.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(locator<InternetConnectionChecker>()),
  );
  setupAuthLocator();
}
