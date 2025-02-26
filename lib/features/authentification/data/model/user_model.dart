import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({required this.username});

  final String username;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json['username']);
  }

  @override
  List<Object?> get props => [username];
}
