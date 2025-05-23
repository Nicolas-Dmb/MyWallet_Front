import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mywallet_mobile/core/application/newtwork_info.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_local_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_remote_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/repositories/auth_repository.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/login_usecase.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/signup_usecase.dart';

final GetIt locator = GetIt.instance;

void setupAuthLocator() {
  //General
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => IAuthRemoteDataSource(locator<http.Client>()),
  );
  locator.registerLazySingleton<AuthLocalDataSource>(
    () => IAuthLocalDataSource(locator<FlutterSecureStorage>()),
  );
  locator.registerLazySingleton<AuthRepositoryContract>(
    () => AuthRepository(
      locator<AuthRemoteDataSource>(),
      locator<AuthLocalDataSource>(),
      locator<NetworkInfo>(),
    ),
  );
  //Signup
  locator.registerFactory<SignupUseCase>(
    () => SignupUseCase(locator<AuthRepositoryContract>()),
  );
  //Login
  locator.registerFactory<LoginUseCase>(
    () => LoginUseCase(locator<AuthRepositoryContract>()),
  );
}
