import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mywallet_mobile/core/application/newtwork_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mywallet_mobile/core/service/auth_session_service.dart';
import 'package:mywallet_mobile/core/service/timer_service.dart';
import 'package:mywallet_mobile/features/authentification/auth_di.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';

final GetIt di = GetIt.instance;

void setupLocator() {
  di.registerLazySingleton(() => FlutterSecureStorage());

  di.registerLazySingleton(() => http.Client());

  di.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
  di.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(di<InternetConnectionChecker>()),
  );
  di.registerFactory<DefaultTimerService>(() => DefaultTimerService());
  di.registerLazySingleton<AuthService>(
    () => AuthService(di<DefaultTimerService>(), di<AuthRepositoryContract>()),
  );
  setupAuthLocator();
}
