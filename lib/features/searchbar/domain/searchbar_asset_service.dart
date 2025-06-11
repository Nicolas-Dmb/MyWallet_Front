import 'package:dartz/dartz.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/features/searchbar/data/searchbar_repository.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/private_assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';

class SearchbarAssetService {
  SearchbarAssetService(this._repository);

  SearchbarAssetService.inject() : this(di<ISearchbarRepository>());

  final SearchbarRepository _repository;

  /// Get Assets from global database then filtered with input user
  Future<Either<Failure, List<AssetModel>>> getGeneralAssets(
    String input,
    AssetFilterType type,
  ) async {
    try {
      final result = await _repository.getGeneralAssets(type);
      return result.fold(
        (failure) => Left(failure),
        (value) => Right(_filter(input, type, value)),
      );
    } catch (e) {
      AppLogger.error(
        'TradingQuizzService.getAssets() : erreur lors du chargement des données',
        e,
      );
      return Left(
        UnknownFailure(
          'Une erreur est survenue lors de la récupération des actifs',
        ),
      );
    }
  }

  /// Get new Assets not yet register in global database from chatGpt
  Future<Either<Failure, List<AssetModel>>> retrieve(
    String input,
    AssetFilterType type,
    List<AssetModel> assets,
  ) async {
    try {
      final result = await _repository.retrieve(input, type);
      return result.fold(
        (failure) => Left(failure),
        (value) => Right(_removeDuplicates(value, assets)),
      );
    } catch (e) {
      AppLogger.error(
        'TradingQuizzService.retrieve() : erreur lors du chargement des données',
        e,
      );
      return Left(
        UnknownFailure(
          'Une erreur est survenue lors de la récupération des nouveaux actifs',
        ),
      );
    }
  }

  List<AssetModel> _filter(
    String input,
    AssetFilterType type,
    List<AssetModel> datas,
  ) {
    final filterByInput = _filterByInput(input, type, datas);
    return _filterByType(type, filterByInput);
  }

  List<AssetModel> _filterByInput(
    String input,
    AssetFilterType type,
    List<AssetModel> datas,
  ) {
    return datas
        .where(
          (asset) => asset.name.contains(input) || asset.ticker.contains(input),
        )
        .toList();
  }

  List<AssetModel> _filterByType(AssetFilterType type, List<AssetModel> datas) {
    return datas.where((asset) => asset.remoteType.name == type.name).toList();
  }

  List<AssetModel> _removeDuplicates(
    List<AssetModel> newDatas,
    List<AssetModel> assets,
  ) {
    List<AssetModel> newList = assets;
    for (var newData in newDatas) {
      if (!assets.contains(newData)) {
        newList.add(newData);
      }
    }
    return newList;
  }

  Future<List<PrivateAssetsModel>> getPrivateAssets(
    PrivateFilterType type,
  ) async {
    final result = await _repository.getPrivateAssets(type);
    return result.fold((failure) => throw failure, (value) => value);
  }

  List<PrivateAssetsModel> filter(
    List<PrivateAssetsModel> assets,
    String input,
  ) {
    return assets.where((asset) {
      if (asset is CashModel) {
        return _filterCash(asset, input);
      } else if (asset is RealEstateModel) {
        return _filterImmo(asset, input);
      }
      return false;
    }).toList();
  }

  bool _filterCash(CashModel asset, String input) {
    return asset.account.contains(input) || asset.bank.contains(input);
  }

  bool _filterImmo(RealEstateModel asset, String input) {
    return asset.address.contains(input) ||
        asset.purpose.contains(input) ||
        asset.type.contains(input);
  }
}
