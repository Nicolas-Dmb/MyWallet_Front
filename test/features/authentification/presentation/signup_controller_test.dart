import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/signup_usecase.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/signup_controller.dart';
import 'package:bloc_test/bloc_test.dart';
import 'signup_controller_test.mocks.dart';

@GenerateMocks([SignupUseCase])
main() {
  late SignupController signupController;
  late MockSignupUseCase mockSignupUseCase;

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    signupController = SignupController(mockSignupUseCase);
  });

  group('submit error Invalid Input', () {
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when email is invalid',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet',
          'wallet',
          'Wallet2025!',
          'Wallet2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when email is not provided',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit('', 'wallet', 'Wallet2025!', 'Wallet2025!');
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when username is not provided',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          '',
          'Wallet2025!',
          'Wallet2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when password is not provided',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          '',
          'Wallet2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when password havent special character',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          'Wallet2025',
          'Wallet2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when password havent number',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          'Wallethbjdeznde!',
          'Wallethbjdeznde!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when password havent enough char',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          'Walle!',
          'Walle!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when password havent maj',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          'wallet2025!',
          'walle2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when password havent maj',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          'WALLET2025!',
          'WALLET2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
    blocTest<SignupController, SubmitState>(
      'Should return UserFailure when password is not similar to confirm_password',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          'Wallet2025!!',
          'Wallet2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockSignupUseCase.call(any));
      },
    );
  });
  group('signup UseCase return', () {
    blocTest<SignupController, SubmitState>(
      'Should return Success when UseCase return Right(true or false)',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer((_) async => Right(false));
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          'Wallet2025!',
          'Wallet2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Succes>()],
    );
    blocTest<SignupController, SubmitState>(
      'Should return Error when UseCase return Left(Failure)',
      build: () => signupController,
      act: (controller) async {
        when(mockSignupUseCase.call(any)).thenAnswer(
          (_) async => Left(RequestFailure('username already exist')),
        );
        await controller.submit(
          'wallet@gmail.com',
          'wallet',
          'Wallet2025!',
          'Wallet2025!',
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
    );
  });
}
