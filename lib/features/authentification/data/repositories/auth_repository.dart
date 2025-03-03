import 'package:dartz/dartz.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_local_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_remote_data_source.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

class AuthRepository implements AuthRepositoryContract {
  AuthRepository(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, bool>> signup(UserSignup userData) async {
    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final remoteSignup = await _remoteDataSource.signup(userData);
      await _localDataSource.cacheUser(remoteSignup);
    } on ServerFailure catch (e) {
      AppLogger.error('ServerFailure: ${e.message}', '');
      return Left(ServerFailure());
    } on RequestFailure catch (e) {
      AppLogger.error('RequestFailure: ${e.message}', '');
      return Left(RequestFailure(e.message));
    } on CacheFailure catch (e) {
      AppLogger.error('CacheFailure: ${e.message}', '');
      return Left(CacheFailure(e.message));
    } catch (e) {
      AppLogger.error('UnknownFailure: Erreur inconnue : $e', '');
      return Left(UnknownFailure("Erreur inconnue : $e"));
    }
    return Right(true);
  }

  @override
  Future<Either<Failure, void>> login(UserLogin userData) async {
    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final result = await _remoteDataSource.login(userData);
      await _localDataSource.cacheToken(result);
    } on ServerFailure catch (e) {
      AppLogger.error('ServerFailure: ${e.message}', '');
      return Left(ServerFailure());
    } on RequestFailure catch (e) {
      AppLogger.error('RequestFailure: ${e.message}', '');
      return Left(RequestFailure(e.message));
    } on CacheFailure catch (e) {
      AppLogger.error('CacheFailure: ${e.message}', '');
      return Left(CacheFailure(e.message));
    } catch (e) {
      AppLogger.error('UnknownFailure: Erreur inconnue : $e', '');
      return Left(UnknownFailure("Erreur inconnue : $e"));
    }
    return Right(null);
  }

  /*
  @override
  Future<Either<Failure, bool>> refreshToken(){
    //TODO : implement
    return null;
  };
  @override
  Future<Either<Failure, bool>> logout(){
    //TODO : implement
    return null
  };*/
}
