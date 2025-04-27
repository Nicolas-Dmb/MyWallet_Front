import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/signup_validators.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

import '../../domain/usecases/signup_usecase.dart' show Params, SignupUseCase;

abstract class SubmitState {}

class Initial extends SubmitState {}

class Logging extends SubmitState {}

class Succes extends SubmitState {}

class Error extends SubmitState {
  Error(this.error);
  final Failure error;
}

class SignupController extends Cubit<SubmitState> {
  SignupController(this._signupUseCase) : super(Initial());

  final SignupUseCase _signupUseCase;

  UserFailure? _isValidData(
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
  ) {
    UserFailure? errorEmail = ValidatorSignup.validatorEmail(email);
    UserFailure? errorUsername = ValidatorSignup.validatorUsername(username);
    UserFailure? errorPassword = ValidatorSignup.validatorPassword(password);
    UserFailure? errorConfirmPassword =
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
    UserFailure? response = _isValidData(
      email,
      username,
      password,
      confirmPassword,
    );
    emit(Logging());
    if (response != null) {
      emit(Error(response));
      return;
    }
    final userData = UserSignup(
      email: email!,
      username: username!,
      password: password!,
      confirmPassword: confirmPassword!,
    );
    final result = await _signupUseCase.call(Params(userData));
    result.fold((failure) => emit(Error(failure)), (value) => emit(Succes()));
    return;
  }
}
