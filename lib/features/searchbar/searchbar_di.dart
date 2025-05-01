import 'package:get_it/get_it.dart';
import 'package:mywallet_mobile/features/searchbar/data/searchbar_remote_data_source.dart';
import 'package:mywallet_mobile/features/searchbar/data/searchbar_repository.dart';
import 'package:mywallet_mobile/features/searchbar/domain/searchbar_asset_service.dart';

final GetIt locator = GetIt.instance;

void setupTradingLocator() {
  locator.registerFactory<SearchbarAssetService>(
    () => SearchbarAssetService.inject(),
  );
  locator.registerFactory<SearchBarRemoteDataSource>(
    () => SearchBarRemoteDataSource.inject(),
  );
  locator.registerFactory<ISearchbarRepository>(
    () => ISearchbarRepository.inject(),
  );
}
