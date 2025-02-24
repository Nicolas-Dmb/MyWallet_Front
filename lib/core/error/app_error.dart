abstract class Failure {
  final String message;
  const Failure(this.message);
}

///Faillure for invalid input
class UserException implements Failure {
  @override
  final String message;
  const UserException(this.message);
}

///Faillure for remote dependancies error
class ServerException implements Failure {
  @override
  final String message;
  const ServerException(this.message);
}

///Faillure for local dependancies error
class StorageException implements Failure {
  @override
  final String message;
  const StorageException(this.message);
}

///Faillure for remote request error
class RequestException implements Failure {
  @override
  final String message;
  const RequestException(this.message);
}
