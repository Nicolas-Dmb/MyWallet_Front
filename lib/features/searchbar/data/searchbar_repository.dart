import 'package:dartz/dartz.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/features/searchbar/data/searchbar_remote_data_source.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';

abstract class SearchbarRepository {
  Future<Either<List<AssetsModel>, Failure>> getAssets();
  Future<Either<List<AssetsModel>, Failure>> retrieve(String input);
  Future<Either<List<AssetsModel>, Failure>> selfAssets(String type);
}

class ISearchbarRepository extends SearchbarRepository {
  ISearchbarRepository(this.authService, this.datasource);

  ISearchbarRepository.inject()
    : this(di<AuthService>(), di<SearchBarRemoteDataSource>());

  final AuthService authService;
  final SearchBarRemoteDataSource datasource;

  @override
  Future<Either<List<AssetsModel>, Failure>> getAssets() async {
    try {
      final accessToken = await authService.getToken();
      if (accessToken == null) {
        return Right(CacheFailure("Erreur d'authentification"));
      }
      final assets = await datasource.getAssets(accessToken);
      return Left(assets);
    } on Failure catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<List<AssetsModel>, Failure>> retrieve(String input) async {
    try {
      final accessToken = await authService.getToken();
      if (accessToken == null) {
        return Right(CacheFailure("Erreur d'authentification"));
      }
      final assets = await datasource.retrieve(accessToken, input);
      return Left(assets);
    } on Failure catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<List<AssetsModel>, Failure>> selfAssets(String type) async {
    try {
      final accessToken = await authService.getToken();
      if (accessToken == null) {
        return Right(CacheFailure("Erreur d'authentification"));
      }
      final assets = await datasource.selfAssets(accessToken, type);
      return Left(assets);
    } on Failure catch (e) {
      return Right(e);
    }
  }
}
