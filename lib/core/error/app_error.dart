import 'dart:convert';

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
  const ServerFailure([
    super.message = "Erreur Serveur: Veuillez réssayer plus tard",
  ]);
}

///Faillure for local dependancies error
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

///Faillure for remote request error
class RequestFailure extends Failure {
  const RequestFailure(super.message);

  factory RequestFailure.getMessage(String responseBody, int statusCode) {
    String response = handleErrorResponse(responseBody);
    return RequestFailure("Erreur client : $statusCode = $response");
  }
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

String handleErrorResponse(String responseBody) {
  try {
    final Map<String, dynamic> errorData = json.decode(responseBody);

    String formattedErrors = errorData.entries
        .map((entry) {
          String field = entry.key;
          dynamic messages = entry.value;
          return "$field: ${messages is List<dynamic> ? messages.join(', ') : messages}";
        })
        .join("\n");

    return formattedErrors;
  } catch (e) {
    return "Erreur inconnue lors de l'analyse des erreurs.";
  }
}
