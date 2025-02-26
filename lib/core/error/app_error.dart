import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}

///Faillure for invalid input
class UserFailure extends Failure {
  const UserFailure(super.message);
}

///Faillure for remote dependancies error
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

///Faillure for local dependancies error
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

///Faillure for remote request error
class RequestFailure extends Failure {
  const RequestFailure(super.message);
}

///Faillure for Network error
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = "Erreur: Veuillez vérifier votre connexion internet",
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
