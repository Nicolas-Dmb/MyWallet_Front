import 'package:get_it/get_it.dart';
import 'package:mywallet_mobile/core/application/newtwork_info.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_local_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_remote_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/repositories/auth_repository.dart';

final GetIt locator = GetIt.instance;

void setupAuthLocator() {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      remoteDataSource: locator<AuthRemoteDataSource>(),
      localDataSource: locator<AuthLocalDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  //TODO: Ajouter toutes les classes ayant des dependances dans auth
}
