import 'package:dartz/dartz.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/features/searchbar/data/searchbar_remote_data_source.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/searchbar_barrel.dart';

abstract class SearchbarRepository {
  Future<Either<Failure, List<AssetModel>>> getGeneralAssets(FilterType type);
  Future<Either<Failure, List<AssetModel>>> retrieve(
    String input,
    FilterType type,
  );
}

class ISearchbarRepository extends SearchbarRepository {
  ISearchbarRepository(this.authService, this.datasource);

  ISearchbarRepository.inject()
    : this(di<AuthService>(), di<SearchBarRemoteDataSource>());

  final AuthService authService;
  final SearchBarRemoteDataSource datasource;

  @override
  Future<Either<Failure, List<AssetModel>>> getGeneralAssets(
    FilterType type,
  ) async {
    try {
      final accessToken = await authService.getToken();
      if (accessToken == null) {
        return Left(CacheFailure("Erreur d'authentification"));
      }
      final assets = await datasource.getGeneralAssets(accessToken, type);
      return Right(assets);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<AssetModel>>> retrieve(
    String input,
    FilterType type,
  ) async {
    try {
      final accessToken = await authService.getToken();
      if (accessToken == null) {
        return Left(CacheFailure("Erreur d'authentification"));
      }
      final assets = await datasource.retrieve(accessToken, input, type);
      return Right(assets);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
