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

      repository.signup(userSignupData);

      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          when(
            mockAuthRemoteDataSource.signup(userSignupData),
          ).thenAnswer((_) async => userModel);

          await repository.signup(userSignupData);

          verify(mockAuthRemoteDataSource.signup(userSignupData));
          verify(mockAuthLocalDataSource.cacheUser(userModel));
        },
      );
    });
  });
}
