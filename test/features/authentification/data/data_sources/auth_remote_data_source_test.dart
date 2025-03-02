import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/features/authentification/data/data_sources/auth_remote_data_source.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
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
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: UserModel.toJson(userData),
          ),
        ).thenAnswer(
          (_) async => http.Response(fixture('registration_fixture.json'), 200),
        );

        final result = await authRemoteDataSource.signup(userData);

        verify(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: UserModel.toJson(userData),
          ),
        );
        final UserModel expectResult = UserModel(username: "PyTestAll");
        expect(result, equals(expectResult));
      },
    );
    test(
      'should perform a post request on a URL whith header and body and return RequestFailure',
      () async {
        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: UserModel.toJson(userData),
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
            body: UserModel.toJson(userData),
          ),
        );
      },
    );
  });
}
