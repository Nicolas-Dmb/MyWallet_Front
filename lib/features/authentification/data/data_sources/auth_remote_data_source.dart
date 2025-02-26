import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signup(UserSignup userData);
  Future<TokenModel> login(UserSignup userData);
  Future<TokenModel> refreshToken(String refreshToken);
  Future<bool> logout(String accessToken);
}
