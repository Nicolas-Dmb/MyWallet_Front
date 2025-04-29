import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/searchbar_service.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';

abstract class SearchbarState {}

class Initial extends SearchbarState {}

class Loading extends SearchbarState {}

class Loaded extends SearchbarState {
  Loaded(this.assets, this.page);
  final List<AssetModel>? assets;
  final int page;
  static int maxPage = 3;
}

class Error extends SearchbarState {
  Error(this.message);

  final String message;
}

class SearchbarController extends Cubit<SearchbarState> {
  SearchbarController(this._searchbarService) : super(Initial());

  final SearchbarService _searchbarService;

  Future<void> search(String input, FilterType filter) async {
    emit(Loading());
    final ownResult = await _getOwnAssets(filter);
    if (ownResult == null) {
      return;
    }
    if (ownResult.length > 5) {
      emit(Loaded(ownResult, 1));
      return;
    }
    if (filter == FilterType.immo || filter == FilterType.cash) {
      emit(Loaded(ownResult, 3));
      return;
    }
    final generalResult = await _getGeneralAssets();
  }

  //for Crypto and Bourse
  Future<List<AssetModel>?> _getOwnAssets(FilterType filter) async {
    final result = await _searchbarService.getOwnAssets(filter);
    return result.fold(
      (failure) {
        emit(Error(failure.message));
      },
      (value) {
        return value;
      },
    );
  }

  List<AssetModel> _addAll(List<AssetModel> value) {
    if (state is! Loaded) {
      return value;
    }
    final currentEmit = state as Loaded;
    var result = value;
    if (currentEmit.assets != null) {
      result.addAll(currentEmit.assets!);
    }
    return result;
  }

  Future<AssetModel> _getGeneralAssets(FilterType type) async {
    final result = await _searchbarService.getGeneralAssets(type);
    return result.fold(
      (failure) {
        emit(Error(failure.message));
      },
      (value) {
        return value;
      },
    );
  }

  Future<void> _getOwnImmoAssets() async {
    //TODO : get Immo Datas
  }
}
