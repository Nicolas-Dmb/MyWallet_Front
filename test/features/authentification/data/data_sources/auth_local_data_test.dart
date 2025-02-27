import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_local_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';

import 'auth_local_data_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
String fixture(String name) =>
    File('test/features/authentification/fixtures/$name').readAsStringSync();

void main() {
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late IAuthLocalDataSource localDataSource;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    localDataSource = IAuthLocalDataSource(mockFlutterSecureStorage);
  });

  group('Token', () {
    final tokenModel = TokenModel.fromJson(
      json.decode(fixture('login_fixture.json')),
    );

    test('Should not return data when token is stored successfully', () async {
      when(
        mockFlutterSecureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
          lOptions: anyNamed('lOptions'),
        ),
      ).thenAnswer((_) async {});

      expect(localDataSource.cacheToken(tokenModel), completes);
    });
    test('Should return CacheException when error in secure storage', () async {
      when(
        mockFlutterSecureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
          lOptions: anyNamed('lOptions'),
        ),
      ).thenThrow(Exception("Storage Error"));

      expect(
        localDataSource.cacheToken(tokenModel),
        throwsA(isA<CacheFailure>()),
      );
    });
    test(
      'Should return token acces when token is receive successfully',
      () async {
        when(
          mockFlutterSecureStorage.read(
            key: 'access',
            iOptions: anyNamed('iOptions'),
            aOptions: anyNamed('aOptions'),
            lOptions: anyNamed('lOptions'),
          ),
        ).thenAnswer((_) async => 'bjzzbkezjb83883');

        final result = await localDataSource.getAccessToken();

        expect(result, equals('bjzzbkezjb83883'));
      },
    );
    test(
      'Should return token refresh when token is receive successfully',
      () async {
        when(
          mockFlutterSecureStorage.read(
            key: 'refresh',
            iOptions: anyNamed('iOptions'),
            aOptions: anyNamed('aOptions'),
            lOptions: anyNamed('lOptions'),
          ),
        ).thenAnswer((_) async => 'bjzzbkezjb83883');

        final result = await localDataSource.getRefreshToken();

        expect(result, equals('bjzzbkezjb83883'));
      },
    );
    test(
      'Should return CacheFailure when token is read unsuccessfully',
      () async {
        when(
          mockFlutterSecureStorage.read(
            key: 'access',
            iOptions: anyNamed('iOptions'),
            aOptions: anyNamed('aOptions'),
            lOptions: anyNamed('lOptions'),
          ),
        ).thenThrow(Exception("Storage Error"));

        expect(
          () => localDataSource.getAccessToken(),
          throwsA(isA<CacheFailure>()),
        );
      },
    );
  });

  group('User', () {
    final userModel = UserModel.fromJson(
      json.decode(fixture('registration_fixture.json')),
    );

    test('Should not return data when user is stored successfully', () async {
      when(
        mockFlutterSecureStorage.write(
          key: 'username',
          value: userModel.username,
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
          lOptions: anyNamed('lOptions'),
        ),
      ).thenAnswer((_) async {});

      expect(localDataSource.cacheUser(userModel), completes);
    });
    test(
      'Should return CacheException when error in secure storage of User',
      () async {
        when(
          mockFlutterSecureStorage.write(
            key: 'username',
            value: userModel.username,
            iOptions: anyNamed('iOptions'),
            aOptions: anyNamed('aOptions'),
            lOptions: anyNamed('lOptions'),
          ),
        ).thenThrow(Exception("Storage Error"));

        await expectLater(
          localDataSource.cacheUser(userModel),
          throwsA(isA<CacheFailure>()),
        );
      },
    );
    test('Should return username when user is receive successfully', () async {
      when(
        mockFlutterSecureStorage.read(
          key: 'username',
          iOptions: anyNamed('iOptions'),
          aOptions: anyNamed('aOptions'),
          lOptions: anyNamed('lOptions'),
        ),
      ).thenAnswer((_) async => userModel.username);

      final result = await localDataSource.getCacheUser();

      expect(result, equals(userModel));
    });
    test(
      'Should return CacheFailure when username is read unsuccessfully',
      () async {
        when(
          mockFlutterSecureStorage.read(
            key: 'username',
            iOptions: anyNamed('iOptions'),
            aOptions: anyNamed('aOptions'),
            lOptions: anyNamed('lOptions'),
          ),
        ).thenThrow(Exception("Storage Error"));

        expect(
          () => localDataSource.getCacheUser(),
          throwsA(isA<CacheFailure>()),
        );
      },
    );
  });
}
