import 'package:dartz/dartz.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

abstract class AuthRepositoryContract {
  Future<Either<Failure, bool>> signup(UserSignup userData);
  /* Future<Either<Failure, bool>> login(UserLogin userData);
  Future<Either<Failure, bool>> refreshToken();
  Future<Either<Failure, bool>> logout();*/
}
