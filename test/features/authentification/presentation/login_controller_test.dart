import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mywallet_mobile/core/service/auth_session_service.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/login_usecase.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/login_controller.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/auth_navigation_controller.dart';

import 'login_controller_test.mocks.dart';

@GenerateMocks([LoginUseCase])
@GenerateMocks([AuthNavigationController])
@GenerateMocks([AuthService])
main() {
  late LoginController loginController;
  late MockLoginUseCase mockloginUseCase;
  late MockAuthNavigationController mockAuthNavigationController;
  late MockAuthSessionService mockAuthSessionService;

  setUp(() {
    mockAuthNavigationController = MockAuthNavigationController();
    mockloginUseCase = MockLoginUseCase();
    mockAuthSessionService = MockAuthSessionService();
    loginController = LoginController(mockloginUseCase, mockAuthSessionService);
  });
  group("login methode", () {
    blocTest<LoginController, LoginState>(
      'Should return Error when User forgot to provide email',
      build: () => loginController,
      act: (controller) async {
        when(mockloginUseCase.call(any)).thenAnswer((_) async => Right(any));
        await controller.login(
          '',
          'TestWallet01!',
          mockAuthNavigationController,
        );
      },
      expect: () => [isA<Logging>(), isA<Error>()],
      verify: (_) {
        verifyNever(mockloginUseCase.call(any));
      },
    );
    blocTest<LoginController, LoginState>(
      'Should return Succes when User send valid data',
      build: () => loginController,
      act: (controller) async {
        when(mockloginUseCase.call(any)).thenAnswer((_) async => Right(null));
        when(mockAuthSessionService.start()).thenAnswer((_) {});
        when(mockAuthNavigationController.goToDashboard()).thenAnswer((_) {});
        await controller.login(
          'TestWallet01@gmail.com',
          'TestWallet01!',
          mockAuthNavigationController,
        );
      },
      expect: () => [isA<Logging>(), isA<Succes>()],
    );
  });
}
