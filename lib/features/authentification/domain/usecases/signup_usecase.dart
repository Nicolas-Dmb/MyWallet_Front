import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mywallet_mobile/features/authentification/domain/contract/auth_repository_contract.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

class SignupUseCase extends UseCase<bool, Params> {
  final AuthRepositoryContract repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.signup(params.userData);
  }
}

class Params extends Equatable {
  final UserSignup userData;

  const Params({required this.userData}) : super();

  @override
  List<Object?> get props => [userData];
}
