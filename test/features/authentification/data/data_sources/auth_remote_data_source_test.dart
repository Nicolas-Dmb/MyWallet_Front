import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_remote_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'auth_remote_data_source_test.mocks.dart';

String fixture(String name) =>
    File('test/features/authentification/fixtures/$name').readAsStringSync();

@GenerateMocks([http.Client])
void main() {
  late IAuthRemoteDataSource authRemoteDataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    authRemoteDataSource = IAuthRemoteDataSource(mockHttpClient);
  });

  group('signup', () {
    final userData = UserSignup(
      username: "PyTestAll",
      email: "n.all@epitech.eu",
      password: 'Wallet2025!',
      confirmPassword: 'Wallet2025!',
    );
    test(
      'should perform a post request on a URL whith header and body and return succes',
      () async {
        final jsonBody = jsonEncode(UserModel.toJson(userData));
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('registration_fixture.json'), 201),
        );

        final result = await authRemoteDataSource.signup(userData);

        verify(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        );
        final UserModel expectResult = UserModel(username: "PyTestAll");
        expect(result, equals(expectResult));
      },
    );
    test(
      'should perform a post request on a URL whith header and body and return RequestFailure',
      () async {
        final jsonBody = jsonEncode(UserModel.toJson(userData));

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(fixture('registration_error_fixture.json'), 400),
        );
        final requestFailure = RequestFailure.getMessage(
          fixture('registration_error_fixture.json'),
          400,
        );
        expect(
          () async => await authRemoteDataSource.signup(userData),
          throwsA(equals(requestFailure)),
        );
        verify(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        );
      },
    );
  });
  group('login', () {
    final userData = UserLogin("n.all@epitech.eu", 'Wallet2025!');
    test(
      'should perform a post request on a URL whith header and body and return succes',
      () async {
        final jsonBody = jsonEncode(UserModel.toJsonLogin(userData));
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('login_fixture.json'), 201),
        );

        final result = await authRemoteDataSource.login(userData);

        verify(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        );
        final TokenModel expectResult = TokenModel(
          tokenAccess: "NDhjZC05ZjQxLWY4MjNmZGY0NjhlZCJ9.8YWHzbzIYkT-",
          tokenRefresh:
              "WQiOiJmOWUzNWM0Ny05NjJlLTQ4Y2QtOWY0MS1mORZrfe5WVTlCBAquc_BaxwNjo",
        );
        expect(result, equals(expectResult));
      },
    );
    test(
      'should perform a post request on a URL whith header and body and return RequestFailure',
      () async {
        final jsonBody = jsonEncode(UserModel.toJsonLogin(userData));

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('login_error_fixture.json'), 401),
        );
        final requestFailure = RequestFailure.getMessage(
          fixture('login_error_fixture.json'),
          401,
        );
        expect(
          () async => await authRemoteDataSource.login(userData),
          throwsA(equals(requestFailure)),
        );
        verify(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        );
      },
    );
  });
  group('refreshToken', () {
    final tokens = TokenModel(
      tokenAccess:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiw",
      tokenRefresh:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaC",
    );
    test(
      'should perform a post request on a URL whith header and body and return succes',
      () async {
        final jsonBody = jsonEncode(tokens.toJson());
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('refreshToken_fixture.json'), 200),
        );

        final result = await authRemoteDataSource.refreshToken(tokens);

        verify(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        );
        final TokenModel expectResult = TokenModel(
          tokenAccess:
              "ItNDZhNy1hODFkLWY2ODMyN2E1NmMyYyJ9.eRRf5axfnqP6GFpWLo2jAuzoFpDyD6QQMM0PB4alWhc",
          tokenRefresh:
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaC",
        );
        expect(result, equals(expectResult));
      },
    );
    test(
      'should perform a post request on a URL whith header and body and return RequestFailure',
      () async {
        final jsonBody = jsonEncode(tokens.toJson());
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(fixture('refreshToken_error_fixture.json'), 401),
        );
        final requestFailure = RequestFailure.getMessage(
          fixture('refreshToken_error_fixture.json'),
          401,
        );
        expect(
          () async => await authRemoteDataSource.refreshToken(tokens),
          throwsA(equals(requestFailure)),
        );
        verify(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonBody,
          ),
        );
      },
    );
  });
}
