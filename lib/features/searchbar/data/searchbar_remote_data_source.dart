import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/core/logger/app_logger.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';

const url = "https://mywalletapi-502906a76c4f.herokuapp.com";

class SearchBarRemoteDataSource {
  SearchBarRemoteDataSource(this._client);

  SearchBarRemoteDataSource.inject() : this(di<http.Client>());

  final http.Client _client;

  Future<List<AssetsModel>> getAssets(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('$url/api/asset/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final assets =
            data
                .map(
                  (asset) => AssetsModel.fromJson(
                    asset,
                    'impossible de charger les données',
                  ),
                )
                .toList();
        return assets;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw RequestFailure.getMessage(response.body, response.statusCode);
      } else if (response.statusCode >= 500) {
        throw ServerFailure(
          "Erreur serveur : ${response.statusCode} = ${response.body}",
        );
      } else {
        AppLogger.error(response.toString(), '');
        throw UnknownFailure(
          "Erreur inconnue : ${response.statusCode} = ${response.body}",
        );
      }
    } catch (e) {
      throw UnknownFailure("Erreur inconnue : ${e.toString()}");
    }
  }

  Future<List<AssetsModel>> retrieve(String token, String input) async {
    try {
      final response = await _client.get(
        Uri.parse('$url/api/general/$input/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final assets =
            data
                .map(
                  (asset) => AssetsModel.fromJson(
                    asset,
                    'aucune données disponible, vous devrez les renseigner manuellement',
                  ),
                )
                .toList();
        return assets;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw RequestFailure.getMessage(response.body, response.statusCode);
      } else if (response.statusCode >= 500) {
        throw ServerFailure(
          "Erreur serveur : ${response.statusCode} = ${response.body}",
        );
      } else {
        AppLogger.error(response.toString(), '');
        throw UnknownFailure(
          "Erreur inconnue : ${response.statusCode} = ${response.body}",
        );
      }
    } catch (e) {
      throw UnknownFailure("Erreur inconnue : ${e.toString()}");
    }
  }

  Future<List<AssetsModel>> selfAssets(String token, String type) async {
    try {
      final response = await _client.get(
        Uri.parse('$url/api/wallet/list/${type}/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final assets =
            data.map((asset) => AssetsModel.fromJson(asset, '')).toList();
        return assets;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw RequestFailure.getMessage(response.body, response.statusCode);
      } else if (response.statusCode >= 500) {
        throw ServerFailure(
          "Erreur serveur : ${response.statusCode} = ${response.body}",
        );
      } else {
        AppLogger.error(response.toString(), '');
        throw UnknownFailure(
          "Erreur inconnue : ${response.statusCode} = ${response.body}",
        );
      }
    } catch (e) {
      throw UnknownFailure("Erreur inconnue : ${e.toString()}");
    }
  }
}
