import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/searchbar_asset_service.dart';
import 'package:mywallet_mobile/features/searchbar/searchbar_screen.dart';

abstract class SearchbarState {}

class Initial extends SearchbarState {}

class Loading extends SearchbarState {}

class AssetLoaded extends SearchbarState {
  AssetLoaded(this.assets, this.page);
  final List<AssetModel> assets;
  final int page;
  static int maxPage = 2;
}

class Error extends SearchbarState {
  Error(this.message);

  final String message;
}

class Selected extends SearchbarState {
  Selected(this.assetModel, this.assetLoaded);
  final AssetLoaded assetLoaded;
  final AssetModel assetModel;
}

class SearchbarController extends Cubit<SearchbarState> {
  SearchbarController(this._searchbarService) : super(Initial());

  SearchbarController.inject() : this(di<SearchbarAssetService>());

  final SearchbarAssetService _searchbarService;

  Future<void> search(String input, AssetFilterType filter) async {
    if (state is AssetLoaded) {
      final currentState = state as AssetLoaded;
      if (currentState.page == 2) {
        return;
      }
    }
    emit(Loading());
    final ownResult = await _getGeneralAssets(input, filter);
    if (ownResult == null) {
      return;
    }
    if (ownResult.length > 5) {
      emit(AssetLoaded(ownResult, 1));
      return;
    }
    final result = await _retrieveNewAssets(input, filter, ownResult);
    if (result == null) {
      return;
    }
    emit(AssetLoaded(result, 2));
    return;
  }

  Future<List<AssetModel>?> _getGeneralAssets(
    String input,
    AssetFilterType type,
  ) async {
    final result = await _searchbarService.getGeneralAssets(input, type);
    return result.fold(
      (failure) {
        emit(Error(failure.message));
        return;
      },
      (value) {
        return value;
      },
    );
  }

  Future<void> retrieve(String input, AssetFilterType type) async {
    assert(state is AssetLoaded);
    final currentState = state as AssetLoaded;
    if (currentState.page == 2) {
      return;
    }
    final result = await _retrieveNewAssets(input, type, currentState.assets);
    if (result == null) {
      return;
    }
    emit(AssetLoaded(result, 2));
    return;
  }

  Future<List<AssetModel>?> _retrieveNewAssets(
    String input,
    AssetFilterType type,
    List<AssetModel> assets,
  ) async {
    final result = await _searchbarService.retrieve(input, type, assets);
    return result.fold(
      (failure) {
        emit(Error(failure.message));
        return;
      },
      (value) {
        return value;
      },
    );
  }

  Future<void> select(AssetModel asset) async {
    if (state is! AssetLoaded) {
      return;
    }
    final currentState = state as AssetLoaded;
    emit(Selected(asset, currentState));
  }

  Future<void> unSelect(AssetModel asset) async {
    if (state is! Selected) {
      return;
    }
    final currentState = state as Selected;
    emit(
      AssetLoaded(
        currentState.assetLoaded.assets,
        currentState.assetLoaded.page,
      ),
    );
  }
}
