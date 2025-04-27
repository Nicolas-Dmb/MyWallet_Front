import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:mywallet_mobile/core/error/app_error.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';

import '../../../../core/usecases/usecase.dart';

class LoginUseCase implements UseCase<void, Params> {
  final AuthRepositoryContract repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.login(params.userData);
  }
}

class Params extends Equatable {
  final UserLogin userData;

  const Params(this.userData) : super();

  @override
  List<Object?> get props => [userData];
}
