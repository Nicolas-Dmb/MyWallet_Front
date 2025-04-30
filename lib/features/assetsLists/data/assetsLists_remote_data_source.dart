// import 'package:http/http.dart' as http;
// import 'package:mywallet_mobile/core/di.dart';
// import 'package:mywallet_mobile/core/service/auth_session_service.dart';

// class AssetsListsRemoteDataSource{
//   AssetsListsRemoteDataSource(this._client);

//   AssetsListsRemoteDataSource.inject() : this(di<http.Client>());

//   final http.Client _client;
//   Future<List<AssetModel>> ownAssets(String token, FilterType type) async {
//     try {
//       final response = await _client.get(
//         Uri.parse('$url/api/wallet/list/${type.name}/'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           "authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body) as List<dynamic>;
//         final assets =
//             data.map((asset) => AssetModel.fromJson(asset, type)).toList();
//         return assets;
//       } else if (response.statusCode >= 400 && response.statusCode < 500) {
//         throw RequestFailure.getMessage(response.body, response.statusCode);
//       } else if (response.statusCode >= 500) {
//         throw ServerFailure(
//           "Erreur serveur : ${response.statusCode} = ${response.body}",
//         );
//       } else {
//         AppLogger.error(response.toString(), '');
//         throw UnknownFailure(
//           "Erreur inconnue : ${response.statusCode} = ${response.body}",
//         );
//       }
//     } catch (e) {
//       throw UnknownFailure("Erreur inconnue : ${e.toString()}");
//     }
//   }
// }
