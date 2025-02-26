import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(TokenModel token);
  Future<TokenModel> getCacheToken();

  Future<void> cacheUser(UserModel userData);
  Future<UserModel> getCacheUser();
}
