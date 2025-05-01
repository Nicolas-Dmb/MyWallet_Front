import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/searchbar_asset_service.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';

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

class SearchbarController extends Cubit<SearchbarState> {
  SearchbarController(this._searchbarService) : super(Initial());

  final SearchbarAssetService _searchbarService;

  Future<void> search(String input, FilterType filter) async {
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
    FilterType type,
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

  Future<void> retrieve(String input, FilterType type) async {
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
    FilterType type,
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
}
