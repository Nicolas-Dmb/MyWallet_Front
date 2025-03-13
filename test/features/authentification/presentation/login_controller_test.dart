import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/login_usecase.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/login_controller.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/auth_navigation_controller.dart';
import 'login_controller_test.mocks.dart';

@GenerateMocks([LoginUseCase])
@GenerateMocks([AuthNavigationController])
main() {
  late LoginController loginController;
  late MockLoginUseCase mockloginUseCase;
  late MockAuthNavigationController mockAuthNavigationController;

  setUp(() {
    mockAuthNavigationController = MockAuthNavigationController();
    mockloginUseCase = MockLoginUseCase();
    loginController = LoginController(mockloginUseCase);
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
  });
}
