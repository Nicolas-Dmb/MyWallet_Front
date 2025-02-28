import 'dart:convert';

import 'package:mywallet_mobile/core/error/app_error.dart';
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

  IAuthRemoteDataSource({required this.client});
  @override
  Future<UserModel> signup(UserSignup userData) async {
    final response = await client.post(
      'https://mywalletapi-502906a76c4f.herokuapp.com/api/user/' as Uri,
      headers: {'Content-Type': 'application/json'},
      body: UserModel.toJson(userData),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw RequestFailure(
        "Erreur client : ${response.statusCode} = ${response.body}",
      );
    } else if (response.statusCode >= 500) {
      throw ServerFailure(
        "Erreur serveur : ${response.statusCode} = ${response.body}",
      );
    } else {
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
