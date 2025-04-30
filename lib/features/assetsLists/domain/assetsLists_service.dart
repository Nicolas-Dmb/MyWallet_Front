// /// Get Assets by type from own wallet
//   Future<Either<Failure, List<AssetModel>>> getOwnAssets(
//     FilterType type,
//   ) async {
//     try {
//       final result = await _repository.ownAssets(type);
//       return result.fold((failure) => Left(failure), (value) => Right(value));
//     } catch (e) {
//       AppLogger.error(
//         'TradingQuizzService.selfAssets() : erreur lors du chargement des données',
//         e,
//       );
//       return Left(
//         UnknownFailure(
//           'Une erreur est survenue lors de la récupération de vos actifs',
//         ),
//       );
//     }
//   }
