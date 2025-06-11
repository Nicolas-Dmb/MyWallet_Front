import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/logger/app_logger.dart';
import 'package:mywallet_mobile/features/searchbar/domain/private_assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/searchbar_asset_service.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';

abstract class PrivateSearchbarState {}

class PrivateSearchbarDefault extends PrivateSearchbarState {}

class PrivateSearchbarInitialing extends PrivateSearchbarState {}

class PrivateSearchbarInitial extends PrivateSearchbarState {
  PrivateSearchbarInitial(this.assets);

  final List<PrivateAssetsModel> assets;
}

class PrivateSearchbarLoading extends PrivateSearchbarState {}

class PrivateSearchbarLoaded extends PrivateSearchbarState {
  PrivateSearchbarLoaded({required this.assetsFiltered, required this.assets});
  final List<PrivateAssetsModel> assetsFiltered;
  final List<PrivateAssetsModel> assets;
}

class PrivateSearchbarError extends PrivateSearchbarState {
  PrivateSearchbarError(this.message);

  final String message;
}

class PrivateSearchbarController extends Cubit<PrivateSearchbarState> {
  PrivateSearchbarController(this.type, this._searchbarService)
    : super(PrivateSearchbarDefault());

  PrivateSearchbarController.inject(PrivateFilterType type)
    : this(type, di<SearchbarAssetService>());

  final SearchbarAssetService _searchbarService;
  final PrivateFilterType type;

  Future<void> _init(PrivateFilterType type) async {
    emit(PrivateSearchbarInitialing());
    try {
      final result = await _searchbarService.getPrivateAssets(type);
      emit(PrivateSearchbarInitial(result));
    } catch (e) {
      AppLogger.error('Erreur lors de la recherche de type : $type', e);
      emit(
        PrivateSearchbarError(
          "Une erreur s'est produite, veuillez réessayer plus tard",
        ),
      );
    }
  }

  Future<void> search(String input) async {
    if (state is PrivateSearchbarDefault) {
      await _init(type);
    }
    while (state is PrivateSearchbarInitialing) {}
    if (state is PrivateSearchbarInitial || state is PrivateSearchbarLoaded) {
      final currentState = state as PrivateSearchbarLoaded;
      emit(PrivateSearchbarLoading());
      final filtered = _searchbarService.filter(currentState.assets, input);
      emit(
        PrivateSearchbarLoaded(
          assetsFiltered: filtered,
          assets: currentState.assets,
        ),
      );
    }
  }
}
