import 'dart:convert';

import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/core/logger/app_logger.dart';
import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'package:http/http.dart' as http;

const url = "https://mywalletapi-502906a76c4f.herokuapp.com";

abstract class AuthRemoteDataSource {
  Future<UserModel> signup(UserSignup userData);
  Future<TokenModel> login(UserLogin userData);
  Future<TokenModel> refreshToken(TokenModel tokens);
}

class IAuthRemoteDataSource implements AuthRemoteDataSource {
  final http.Client _client;

  IAuthRemoteDataSource(this._client);
  @override
  Future<UserModel> signup(UserSignup userData) async {
    final response = await _client.post(
      Uri.parse('$url/api/user/'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(UserModel.toJson(userData)),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(json.decode(response.body));
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
  }

  @override
  Future<TokenModel> login(UserLogin userData) async {
    final response = await _client.post(
      Uri.parse('$url/api/token/'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(UserModel.toJsonLogin(userData)),
    );
    if (response.statusCode == 200) {
      return TokenModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw RequestFailure.getMessage(
        'email ou mot de passe invalid',
        response.statusCode,
      );
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
  }

  @override
  Future<TokenModel> refreshToken(TokenModel tokens) async {
    final response = await _client.post(
      Uri.parse('$url/api/token/refresh/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': tokens.tokenAccess,
      },
      body: jsonEncode(tokens.toJson()),
    );
    if (response.statusCode == 200) {
      return tokens.refreshFromJson(jsonDecode(response.body));
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
  }
}
