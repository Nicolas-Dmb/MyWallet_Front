import 'dart:convert';

import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/core/logger/app_logger.dart';
import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<UserModel> signup(UserSignup userData); /*
  Future<TokenModel> login(UserSignup userData);
  Future<TokenModel> refreshToken(String refreshToken);
  Future<bool> logout(String accessToken);*/
}

class IAuthRemoteDataSource implements AuthRemoteDataSource {
  final http.Client client;

  IAuthRemoteDataSource(this.client);
  @override
  Future<UserModel> signup(UserSignup userData) async {
    final response = await client.post(
      Uri.parse('https://mywalletapi-502906a76c4f.herokuapp.com/api/user/'),
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

  /*
  Future<TokenModel> login(UserSignup userData);
  Future<TokenModel> refreshToken(String refreshToken);
  Future<bool> logout(String accessToken);*/
}
