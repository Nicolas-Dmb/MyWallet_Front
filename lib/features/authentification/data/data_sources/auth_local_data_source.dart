import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(TokenModel token);
  Future<String> getAccessToken();
  Future<String> getRefreshToken();

  Future<void> cacheUser(UserModel userData);
  Future<UserModel> getCacheUser();
}

class IAuthLocalDataSource implements AuthLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

  const IAuthLocalDataSource(this.flutterSecureStorage);

  @override
  Future<void> cacheToken(TokenModel tokens) async {
    try {
      await flutterSecureStorage.write(
        key: 'access',
        value: tokens.tokenAccess,
      );
      await flutterSecureStorage.write(
        key: 'refresh',
        value: tokens.tokenRefresh,
      );
    } catch (e) {
      throw CacheFailure(
        'Error: impossible de stocker les tokens en mémoire $e',
      );
    }
  }

  @override
  Future<String> getAccessToken() async {
    try {
      String value = await _getCache('access');
      return value;
    } on CacheFailure catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<String> getRefreshToken() async {
    try {
      String value = await _getCache('refresh');
      return value;
    } on CacheFailure catch (e) {
      throw CacheFailure(e.message);
    }
  }

  Future<String> _getCache(String value) async {
    try {
      String? response = await flutterSecureStorage.read(key: value);
      if (response == null) {
        throw CacheFailure(
          "Error: Aucune valeur en mémoire pour l'élément $value",
        );
      }
      return response;
    } catch (e) {
      throw CacheFailure(
        "Error: impossible de récupérer l'élément $value en mémoire $e",
      );
    }
  }

  @override
  Future<void> cacheUser(UserModel userData) async {
    try {
      await flutterSecureStorage.write(
        key: 'username',
        value: userData.username,
      );
    } catch (e) {
      throw CacheFailure(
        "Error: impossible de stocker l'username en mémoire $e",
      );
    }
  }

  @override
  Future<UserModel> getCacheUser() async {
    try {
      String value = await _getCache('username');
      return UserModel(username: value);
    } on CacheFailure catch (e) {
      throw CacheFailure(e.message);
    }
  }
}
