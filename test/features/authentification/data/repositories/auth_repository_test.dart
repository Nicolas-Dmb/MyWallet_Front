import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_local_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_remote_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
import 'package:mywallet_mobile/features/authentification/data/repositories/auth_repository.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([NetworkInfo])
@GenerateMocks([AuthLocalDataSource])
@GenerateMocks([AuthRemoteDataSource])
void main() {
  late AuthRepository repository;
  late MockNetworkInfo mockNetworkInfo;
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepository(
      remoteDataSource: mockAuthRemoteDataSource,
      localDataSource: mockAuthLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('Signup User', () {
    final UserSignup userSignupData = UserSignup(
      email: 'wallet@wallet.com',
      username: 'wallet',
      password: 'Wallet2025!',
      confirmPassword: 'Wallet2025!',
    );
    final userModel = UserModel(username: 'wallet');

    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockAuthRemoteDataSource.signup(userSignupData),
      ).thenAnswer((_) async => userModel);

      repository.signup(userSignupData);

      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'Should return remote data when the call to remote data source is successful',
        () async {
          when(
            mockAuthRemoteDataSource.signup(userSignupData),
          ).thenAnswer((_) async => userModel);

          final result = await repository.signup(userSignupData);

          verify(mockAuthRemoteDataSource.signup(userSignupData));
          expect(result, equals(Right(true)));
        },
      );
      test(
        'Should cache the data locally when the call to remote data source is succesful',
        () async {
          when(
            mockAuthRemoteDataSource.signup(userSignupData),
          ).thenAnswer((_) async => userModel);

          await repository.signup(userSignupData);

          verify(mockAuthRemoteDataSource.signup(userSignupData));
          verify(mockAuthLocalDataSource.cacheUser(userModel));
        },
      );
      test(
        'Should return server failure when the call to remote data source is unsuccesful',
        () async {
          when(
            mockAuthRemoteDataSource.signup(userSignupData),
          ).thenThrow(ServerFailure("erreur server"));

          final result = await repository.signup(userSignupData);

          verify(mockAuthRemoteDataSource.signup(userSignupData));
          verifyZeroInteractions(mockAuthLocalDataSource);
          expect(result, equals(Left(ServerFailure("erreur server"))));
        },
      );
      test(
        'Should return request failure when the call to remote data source is unsuccesful',
        () async {
          when(
            mockAuthRemoteDataSource.signup(userSignupData),
          ).thenThrow(RequestFailure("erreur de requête"));

          final result = await repository.signup(userSignupData);

          verify(mockAuthRemoteDataSource.signup(userSignupData));
          verifyZeroInteractions(mockAuthLocalDataSource);
          expect(result, equals(Left(RequestFailure("erreur de requête"))));
        },
      );
      test(
        'Should return request Unknown Failure when the call to remote data source is unsuccesful',
        () async {
          when(
            mockAuthRemoteDataSource.signup(userSignupData),
          ).thenThrow(Exception("Une erreur inconnue"));

          final result = await repository.signup(userSignupData);

          verify(mockAuthRemoteDataSource.signup(userSignupData));
          verifyZeroInteractions(mockAuthLocalDataSource);
          expect(
            result,
            equals(
              Left(
                UnknownFailure(
                  "Erreur inconnue : Exception: Une erreur inconnue",
                ),
              ),
            ),
          );
        },
      );
      test(
        'Should return Cache Failure when cache user is unsuccesful',
        () async {
          when(
            mockAuthRemoteDataSource.signup(userSignupData),
          ).thenAnswer((_) async => userModel);
          when(
            mockAuthLocalDataSource.cacheUser(userModel),
          ).thenThrow(CacheFailure("Error cache Failure"));

          final result = await repository.signup(userSignupData);

          verify(mockAuthRemoteDataSource.signup(userSignupData));
          verify(mockAuthLocalDataSource.cacheUser(userModel));
          expect(result, equals(Left(CacheFailure("Error cache Failure"))));
        },
      );
    });
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('Should return NetworkFailure', () async {
        final result = await repository.signup(userSignupData);

        verifyZeroInteractions(mockAuthRemoteDataSource);
        verifyZeroInteractions(mockAuthLocalDataSource);
        expect(
          result,
          equals(
            Left(
              NetworkFailure(
                "Erreur: Veuillez vérifier votre connexion internet",
              ),
            ),
          ),
        );
      });
    });
  });
}
