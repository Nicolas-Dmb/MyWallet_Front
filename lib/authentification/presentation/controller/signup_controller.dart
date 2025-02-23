import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/authentification/presentation/controller/signup_validators.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

abstract class SubmitState {}

class Initial extends SubmitState {}

class Logging extends SubmitState {}

class Succes extends SubmitState {}

class Error extends SubmitState {
  Error(this.error);
  final Failure error;
}

class SignupController extends Cubit<SubmitState> {
  SignupController() : super(Initial());

  UserException? _isValidData(
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
  ) {
    UserException? errorEmail = ValidatorSignup.validatorEmail(email);
    UserException? errorUsername = ValidatorSignup.validatorUsername(username);
    UserException? errorPassword = ValidatorSignup.validatorPassword(password);
    UserException? errorConfirmPassword =
        ValidatorSignup.validatorConfirmPassword(password, confirmPassword);
    if (errorEmail != null) {
      return errorEmail;
    } else if (errorUsername != null) {
      return errorUsername;
    } else if (errorPassword != null) {
      return errorPassword;
    } else if (errorConfirmPassword != null) {
      return errorConfirmPassword;
    }
    return null;
  }

  Future<void> submit(
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
  ) async {
    UserException? response = _isValidData(
      email,
      username,
      password,
      confirmPassword,
    );
    emit(Logging());
    if (response != null) {
      emit(Error(response));
    }
  }
}
