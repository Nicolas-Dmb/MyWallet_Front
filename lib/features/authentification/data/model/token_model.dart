import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  const TokenModel({required this.tokenAccess, required this.tokenRefresh});
  final String tokenAccess;
  final String tokenRefresh;

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      tokenAccess: json['access'],
      tokenRefresh: json['refresh'],
    );
  }
  Map<String, dynamic> toJson() {
    return {"refresh": tokenRefresh};
  }

  @override
  List<Object?> get props => [tokenAccess, tokenRefresh];
}
