import 'package:dartz/dartz.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/features/searchbar/data/searchbar_repository.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';

class SearchbarService {
  SearchbarService(this._repository);

  SearchbarService.inject() : this(di<ISearchbarRepository>());

  final SearchbarRepository _repository;

  /// Get Assets by type from own wallet
  Future<Either<Failure, List<AssetModel>>> getOwnAssets(
    FilterType type,
  ) async {
    try {
      final result = await _repository.ownAssets(type);
      return result.fold((failure) => Left(failure), (value) => Right(value));
    } catch (e) {
      AppLogger.error(
        'TradingQuizzService.selfAssets() : erreur lors du chargement des données',
        e,
      );
      return Left(
        UnknownFailure(
          'Une erreur est survenue lors de la récupération de vos actifs',
        ),
      );
    }
  }

  /// Get Assets from global database then filtered with input user
  Future<Either<Failure, List<AssetModel>>> getGeneralAssets(
    String input,
    FilterType type,
  ) async {
    try {
      final result = await _repository.getGeneralAssets(type);
      return result.fold((failure) => Left(failure), (value) => Right(value));
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
    FilterType type,
  ) async {
    try {
      final result = await _repository.retrieve(input, type);
      return result.fold((failure) => Left(failure), (value) => Right(value));
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
}
