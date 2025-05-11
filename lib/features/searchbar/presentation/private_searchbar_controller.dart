import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/private_assets_model.dart';

abstract class PrivateSearchbarState {}

class Initial extends PrivateSearchbarState {}

class Loading extends PrivateSearchbarState {}

class AssetLoaded extends PrivateSearchbarState {
  AssetLoaded(this.assets, this.page);
  final List<PrivateAssetsModel> assets;
  final int page;
  static int maxPage = 2;
}

class Error extends PrivateSearchbarState {
  Error(this.message);

  final String message;
}

class Selected extends PrivateSearchbarState {
  Selected(this.assetModel, this.assetLoaded);
  final AssetLoaded assetLoaded;
  final AssetModel assetModel;
}

class PrivateSearchbarController extends Cubit<PrivateSearchbarState> {
  PrivateSearchbarController() : super(Initial());

  PrivateSearchbarController.inject() : this();
}
