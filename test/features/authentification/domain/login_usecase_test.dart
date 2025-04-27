import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/login_usecase.dart';
import 'package:mywallet_mobile/core/error/app_error.dart';

import 'signup_usecase_test.mocks.dart';

@GenerateMocks([AuthRepositoryContract])
void main() {
  late LoginUseCase usecase;
  late MockAuthRepositoryContract mockAuthRepositoryContract;

  setUp(() {
    mockAuthRepositoryContract = MockAuthRepositoryContract();
    usecase = LoginUseCase(mockAuthRepositoryContract);
  });

  final UserLogin userLoginData = UserLogin('wallet@wallet.com', 'Wallet2025!');

  test('should get void for the user signup repository', () async {
    when(
      mockAuthRepositoryContract.login(any),
    ).thenAnswer((_) async => Right(null));

    final result = await usecase.call(Params(userLoginData));

    expect(result, Right(null));

    verify(mockAuthRepositoryContract.login(userLoginData));

    verifyNoMoreInteractions(mockAuthRepositoryContract);
  });
  final RequestFailure failure = RequestFailure('Une erreur 400 est survenue');
  test('should get failure for the user signup repository', () async {
    when(
      mockAuthRepositoryContract.login(any),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase.call(Params(userLoginData));

    expect(result, Left(failure));

    verify(mockAuthRepositoryContract.login(userLoginData));

    verifyNoMoreInteractions(mockAuthRepositoryContract);
  });
}
