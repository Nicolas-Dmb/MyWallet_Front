import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mywallet_mobile/core/application/newtwork_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mywallet_mobile/core/service/auth_session_service.dart';
import 'package:mywallet_mobile/core/service/timer_service.dart';
import 'package:mywallet_mobile/features/authentification/auth_di.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FlutterSecureStorage());

  locator.registerLazySingleton(() => http.Client());

  locator.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(locator<InternetConnectionChecker>()),
  );
  locator.registerLazySingleton<AuthSessionService>(
    () => AuthSessionService(
      locator<TimerService>(),
      locator<AuthRepositoryContract>(),
    ),
  );
  setupAuthLocator();
}
