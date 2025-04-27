import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_local_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_remote_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
import 'package:mywallet_mobile/features/authentification/data/repositories/auth_repository.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
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
      mockAuthRemoteDataSource,
      mockAuthLocalDataSource,
      mockNetworkInfo,
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
    final tokenResult = TokenModel(
      tokenAccess: 'jzehjb',
      tokenRefresh: 'defrez',
    );

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
        'Should cache the data locally when the call to remote data source is successful',
        () async {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            mockAuthRemoteDataSource.signup(userSignupData),
          ).thenAnswer((_) async => userModel);
          when(
            mockAuthRemoteDataSource.login(
              argThat(
                isA<UserLogin>()
                    .having((u) => u.email, 'email', userSignupData.email)
                    .having(
                      (u) => u.password,
                      'password',
                      userSignupData.password,
                    ),
              ),
            ),
          ).thenAnswer((_) async => tokenResult);
          when(
            mockAuthLocalDataSource.cacheToken(tokenResult),
          ).thenAnswer((_) async {});

          final result = await repository.signup(userSignupData);

          expect(result, equals(const Right(null)));
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
          expect(
            result,
            equals(
              Left(
                ServerFailure("Erreur Serveur: Veuillez réssayer plus tard"),
              ),
            ),
          );
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
  group('login', () {
    const loginData = UserLogin('test@gmail.com', 'testUser1234!');
    const tokenModel = TokenModel(
      tokenAccess: '123JKdbehnjkdz',
      tokenRefresh: '1234jicz8!',
    );
    test('logged succesfully', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockAuthRemoteDataSource.login(loginData),
      ).thenAnswer((_) async => tokenModel);
      when(
        mockAuthLocalDataSource.cacheToken(tokenModel),
      ).thenAnswer((_) async {});
      // Act
      final result = await repository.login(loginData);

      // Assert
      expect(result.isRight(), true);
    });
    test('logged unsuccesfully RequestFailure', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockAuthRemoteDataSource.login(loginData),
      ).thenThrow(RequestFailure('erreur'));

      final result = await repository.login(loginData);
      expect(result, equals(Left(RequestFailure('erreur'))));
      verifyZeroInteractions(mockAuthLocalDataSource);
    });
    test('logged unsuccesfully CacheFailure', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockAuthRemoteDataSource.login(loginData),
      ).thenAnswer((_) async => tokenModel);
      when(
        mockAuthLocalDataSource.cacheToken(tokenModel),
      ).thenThrow(CacheFailure('erreur'));
      final result = await repository.login(loginData);
      expect(result, equals(Left(CacheFailure('erreur'))));
    });
  });
  group('refreshToken', () {
    const tokenModel = TokenModel(
      tokenAccess: '123JKdbehnjkdz',
      tokenRefresh: '1234jicz8!',
    );
    test('refresh succesfully', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockAuthLocalDataSource.getToken(),
      ).thenAnswer((_) async => tokenModel);
      when(
        mockAuthRemoteDataSource.refreshToken(tokenModel),
      ).thenAnswer((_) async => tokenModel);
      when(
        mockAuthLocalDataSource.cacheToken(tokenModel),
      ).thenAnswer((_) async {});
      final result = await repository.refreshToken();

      expect(result.isRight(), true);
    });
    test('refresh unsuccesfully RequestFailure', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockAuthLocalDataSource.getToken(),
      ).thenAnswer((_) async => tokenModel);
      when(
        mockAuthRemoteDataSource.refreshToken(tokenModel),
      ).thenThrow(RequestFailure('erreur'));

      final result = await repository.refreshToken();
      expect(result, equals(Left(RequestFailure('erreur'))));
    });
    test('refresh unsuccesfully CacheFailure', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        mockAuthLocalDataSource.getToken(),
      ).thenAnswer((_) async => tokenModel);
      when(
        mockAuthRemoteDataSource.refreshToken(tokenModel),
      ).thenAnswer((_) async => tokenModel);
      when(
        mockAuthLocalDataSource.cacheToken(tokenModel),
      ).thenThrow(CacheFailure('erreur'));
      final result = await repository.refreshToken();
      expect(result, equals(Left(CacheFailure('erreur'))));
    });
    test(
      'refresh unsuccesfully CacheFailure when get tokens in local',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockAuthLocalDataSource.getToken(),
        ).thenThrow(CacheFailure('erreur'));
        final result = await repository.refreshToken();
        expect(result, equals(Left(CacheFailure('erreur'))));
        verifyZeroInteractions(mockAuthRemoteDataSource);
      },
    );
  });
  group('getAccessToken', () {
    const tokenModel = TokenModel(
      tokenAccess: '123JKdbehnjkdz',
      tokenRefresh: '1234jicz8!',
    );
    test('Should return Right value', () async {
      when(
        mockAuthLocalDataSource.getToken(),
      ).thenAnswer((_) async => tokenModel);

      final result = await repository.getAccessToken();
      expect(result, equals(Right(tokenModel.tokenAccess)));
    });
    test('Should return Left value', () async {
      when(
        mockAuthLocalDataSource.getToken(),
      ).thenThrow(CacheFailure('erreur'));

      final result = await repository.getAccessToken();
      expect(result, equals(Left(CacheFailure('erreur'))));
    });
  });
  group('logout', () {
    test('Should return Right', () async {
      when(mockAuthLocalDataSource.clearAll()).thenAnswer((_) async {});

      final result = await repository.logout();
      expect(result, equals(Right(null)));
    });
    test('Should return Left', () async {
      when(
        mockAuthLocalDataSource.clearAll(),
      ).thenThrow(CacheFailure('erreur'));

      final result = await repository.logout();
      expect(result, equals(Left(CacheFailure('erreur'))));
    });
  });
}
