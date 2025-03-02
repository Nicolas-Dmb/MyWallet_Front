import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/signup_usecase.dart';
import 'package:mywallet_mobile/core/error/app_error.dart';

import 'signup_usecase_test.mocks.dart';

@GenerateMocks([AuthRepositoryContract])
void main() {
  late SignupUseCase usecase;
  late MockAuthRepositoryContract mockAuthRepositoryContract;

  setUp(() {
    mockAuthRepositoryContract = MockAuthRepositoryContract();
    usecase = SignupUseCase(mockAuthRepositoryContract);
  });

  final UserSignup userSignupData = UserSignup(
    email: 'wallet@wallet.com',
    username: 'wallet',
    password: 'Wallet2025!',
    confirmPassword: 'Wallet2025!',
  );
  final assertResponse = true;

  test('should get bool for the user signup repository', () async {
    when(
      mockAuthRepositoryContract.signup(any),
    ).thenAnswer((_) async => Right(assertResponse));

    final result = await usecase.call(Params(userSignupData));

    expect(result, Right(assertResponse));

    verify(mockAuthRepositoryContract.signup(userSignupData));

    verifyNoMoreInteractions(mockAuthRepositoryContract);
  });
  final RequestFailure failure = RequestFailure('Une erreur 400 est survenue');
  test('should get failure for the user signup repository', () async {
    when(
      mockAuthRepositoryContract.signup(any),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase.call(Params(userSignupData));

    expect(result, Left(failure));

    verify(mockAuthRepositoryContract.signup(userSignupData));

    verifyNoMoreInteractions(mockAuthRepositoryContract);
  });
}
