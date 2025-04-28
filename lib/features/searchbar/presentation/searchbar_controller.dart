import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/searchbar_service.dart';

abstract class SearchbarState {}

class Initial extends SearchbarState {}

class Loading extends SearchbarState {}

class Loaded extends SearchbarState {
  Loaded(this.assets);
  final List<AssetsModel> assets;
}

class Error extends SearchbarState {}

class SearchbarController extends Cubit<SearchbarState> {
  SearchbarController(this._searchbarService) : super(Initial());

  final SearchbarService _searchbarService;

  Future<void> getOwnCryptoAssets() async {
    emit(Loading());
    final result = await _searchbarService.getOwnAssets('crypto');
  }

  Future<void> getOwnBourseAssets() async {
    emit(Loading());
    final result = await _searchbarService.getOwnAssets('crypto');
  }

  Future<void> getOwnCashAssets() async {
    //TODO : get Cash Datas
  }
  Future<void> getOwnImmoAssets() async {
    //TODO : get Immo Datas
  }
}
