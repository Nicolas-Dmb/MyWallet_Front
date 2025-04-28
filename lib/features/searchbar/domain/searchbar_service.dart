import 'package:dartz/dartz.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/features/searchbar/data/searchbar_repository.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';

class SearchbarService {
  SearchbarService(this._repository);

  SearchbarService.inject() : this(di<ISearchbarRepository>());

  final SearchbarRepository _repository;

  /// Get Assets by type from own wallet
  Future<Either<List<AssetsModel>, Failure>> getOwnAssets(String type) async {
    try {
      final result = await _repository.selfAssets(type);
      return result;
    } catch (e) {
      AppLogger.error(
        'TradingQuizzService.selfAssets() : erreur lors du chargement des données',
        e,
      );
      return Right(
        UnknownFailure(
          'Une erreur est survenue lors de la récupération de vos actifs',
        ),
      );
    }
  }

  /// Get Assets from global database then filtered with input user
  Future<Either<List<AssetsModel>, Failure>> getAssets(
    String input,
    String type,
  ) async {
    try {
      return await _repository.getAssets();
    } catch (e) {
      AppLogger.error(
        'TradingQuizzService.getAssets() : erreur lors du chargement des données',
        e,
      );
      return Right(
        UnknownFailure(
          'Une erreur est survenue lors de la récupération des actifs',
        ),
      );
    }
  }

  /// Get new Assets not yet register in global database from chatGpt
  Future<Either<List<AssetsModel>, Failure>> retrieve(String input) async {
    try {
      return await _repository.retrieve(input);
    } catch (e) {
      AppLogger.error(
        'TradingQuizzService.retrieve() : erreur lors du chargement des données',
        e,
      );
      return Right(
        UnknownFailure(
          'Une erreur est survenue lors de la récupération des nouveaux actifs',
        ),
      );
    }
  }
}
