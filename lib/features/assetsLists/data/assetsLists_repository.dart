  // @override
  // Future<Either<Failure, List<AssetModel>>> ownAssets(FilterType type) async {
  //   try {
  //     final accessToken = await authService.getToken();
  //     if (accessToken == null) {
  //       return Left(CacheFailure("Erreur d'authentification"));
  //     }
  //     final assets = await datasource.ownAssets(accessToken, type);
  //     return Right(assets);
  //   } on Failure catch (e) {
  //     return Left(e);
  //   }
  // }