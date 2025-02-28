import 'package:equatable/equatable.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_signup.dart';

class UserModel extends Equatable {
  final String? email;
  final String username;
  final String? password;
  final String? confirmPassword;

  const UserModel({
    this.email,
    required this.username,
    this.password,
    this.confirmPassword,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json['username']);
  }

  static Map<String, dynamic> toJson(UserSignup user) {
    return {
      'email': user.email,
      'username': user.username,
      'password': user.password,
      'confirmPassword': user.confirmPassword,
    };
  }

  @override
  List<Object?> get props => [username, email, password, confirmPassword];
}
