import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubmitState {}

class Initial extends SubmitState {}

class Logging extends SubmitState {}

class Succes extends SubmitState {}

class Error extends SubmitState {
  Error(this.errorMessage);
  final String errorMessage;
}

class SignupController extends Cubit<SubmitState> {
  Future<void> _isValidData() {}
  Future<void> submit() {}
}
