import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/login_usecase.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/navigation_controller.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/signup_validators.dart';

abstract class LoginState {}

class Initial extends LoginState {}

class Logging extends LoginState {}

class Succes extends LoginState {}

class Error extends LoginState {
  final Failure error;
  Error(this.error);
}

class LoginController extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  LoginController(this._loginUseCase) : super(Initial());

  UserFailure? _validator(String? email, String? password) {
    UserFailure? errorEmail = ValidatorSignup.validatorEmail(email);
    UserFailure? errorPassword = ValidatorSignup.validatorPassword(password);
    if (errorEmail != null) {
      return errorEmail;
    } else if (errorPassword != null) {
      return errorPassword;
    }
    return null;
  }

  Future<void> login(
    String? email,
    String? password,
    NavigationController navigationController,
  ) async {
    emit(Logging());
    final validatorResult = _validator(email, password);
    if (validatorResult != null) {
      emit(Error(validatorResult));
      return;
    }
    final userLogin = UserLogin(email!, password!);
    final result = await _loginUseCase.call(Params(userLogin));
    result.fold((failure) => emit(Error(failure)), (r) {
      navigationController.goToDashboard();
      emit(Succes());
    });
    return;
  }
}
