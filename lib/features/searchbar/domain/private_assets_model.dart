import 'package:mywallet_mobile/features/searchbar/searchbar_screen.dart';

abstract class PrivateAssetsModel {
  String get id;
  static PrivateAssetsModel fromJson(
    Map<String, dynamic> json,
    PrivateFilterType type,
  ) {
    switch (type) {
      case PrivateFilterType.cash:
        return CashModel.fromJson(json);
      case PrivateFilterType.immo:
        return RealEstateModel.fromJson(json);
    }
  }
}

class RealEstateModel extends PrivateAssetsModel {
  RealEstateModel({
    required this.id,
    required this.address,
    required this.type,
    required this.purpose,
  });
  @override
  final String id;
  final String address;
  final String type;
  final String purpose;

  static RealEstateModel fromJson(Map<String, dynamic> data) {
    return RealEstateModel(
      id: data['id'],
      address: data['adresse'] ?? '',
      type: data['type'],
      purpose: data['destination'],
    );
  }
}

class CashModel extends PrivateAssetsModel {
  CashModel({
    required this.id,
    required this.bank,
    required this.account,
    required this.amount,
  });
  @override
  final String id;
  final String bank;
  final String account;
  final int amount;

  static CashModel fromJson(Map<String, dynamic> data) {
    return CashModel(
      id: data['id'] ?? '',
      bank: data['bank'] ?? '',
      account: data['account'] ?? '',
      amount: data['amount'] ?? 0,
    );
  }
}
