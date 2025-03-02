import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/signup_usecase.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/signup_controller.dart';

import 'signup_controller_test.mocks.dart';

@GenerateMocks([SignupUseCase])
main() {
  late SignupController signupController;
  late MockSignupUseCase mockSignupUseCase;

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    //signupController(mockSignupUseCase);
  });

  group('submit', () {
    test('Should return UserFailure', () {});
  });
}
