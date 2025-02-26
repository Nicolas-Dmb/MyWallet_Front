import 'package:dartz/dartz.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_local_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_remote_data_source.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

class AuthRepository implements AuthRepositoryContract{
  const AuthRepository({ required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo,});
  
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  @override
  Future<Either<Failure, bool>> signup(UserSignup userData){
    networkInfo.isConnected;
    final remoteSignup = await remoteDataSource.signup(userData);
    localDataSource.cacheUser(remoteSignup);
    bool response = true;
    return Right(response);
  };
  @override
  Future<Either<Failure, bool>> login(UserLogin userData){
    //TODO : implement
    return null;
  };
  @override
  Future<Either<Failure, bool>> refreshToken(){
    //TODO : implement
    return null;
  };
  @override
  Future<Either<Failure, bool>> logout(){
    //TODO : implement
    return null
  };
}


