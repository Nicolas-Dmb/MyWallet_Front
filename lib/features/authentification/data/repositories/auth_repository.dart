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
  Future<Either<Failure, void>> signup(UserSignup userData) async {
    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkFailure());
    }
    try {
      await _remoteDataSource.signup(userData);
      final result = await _remoteDataSource.login(
        UserLogin(userData.email, userData.password),
      );
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

  @override
  Future<Either<Failure, void>> refreshToken() async {
    final bool isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final tokens = await _localDataSource.getToken();
      final newTokens = await _remoteDataSource.refreshToken(tokens);
      await _localDataSource.cacheToken(newTokens);
      return Right(null);
    } on CacheFailure catch (e) {
      AppLogger.error('CacheFailure: ${e.message}', '');
      return Left(CacheFailure(e.message));
    } on ServerFailure catch (e) {
      AppLogger.error('ServerFailure: ${e.message}', '');
      return Left(ServerFailure(e.message));
    } on RequestFailure catch (e) {
      AppLogger.error('RequestFailure: ${e.message}', '');
      return Left(RequestFailure(e.message));
    } catch (e) {
      AppLogger.error('UnknownFailure: Erreur inconnue : $e', '');
      return Left(UnknownFailure("Erreur inconnue : $e"));
    }
  }

  @override
  Future<Either<Failure, String>> getAccessToken() async {
    try {
      final tokens = await _localDataSource.getToken();
      return Right(tokens.tokenAccess);
    } on CacheFailure catch (e) {
      AppLogger.error('CacheFailure: ${e.message}', '');
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearAll();
      return Right(null);
    } on CacheFailure catch (e) {
      AppLogger.error('CacheFailure: ${e.message}', '');
      return Left(CacheFailure(e.message));
    }
  }
}
