import 'package:equatable/equatable.dart';
import 'package:mywallet_mobile/features/authentification/domain/entities/user_login.dart';
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

  static Map<String, String> toJson(UserSignup user) {
    return {
      'email': user.email,
      'username': user.username,
      'password': user.password,
      'confirm_password': user.confirmPassword,
    };
  }

  static Map<String, String> toJsonLogin(UserLogin user) {
    return {'email': user.email, 'password': user.password};
  }

  @override
  List<Object?> get props => [username, email, password, confirmPassword];
}
