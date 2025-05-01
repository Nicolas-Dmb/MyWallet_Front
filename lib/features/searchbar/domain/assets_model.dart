import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';

enum RemoteType { bourse, crypto }

abstract class AssetModel {
  RemoteType get remoteType;
  String get name;
  String get ticker;
  static AssetModel fromJson(Map<String, dynamic> json, FilterType type) {
    switch (type) {
      case FilterType.bourse:
        return StockModel.fromJson(json);
      case FilterType.crypto:
        return CryptoModel.fromJson(json);
    }
  }
}

class CryptoModel extends AssetModel {
  CryptoModel({
    required this.id,
    required this.ticker,
    required this.name,
    this.subtype,
    this.country,
    this.error,
    required this.remoteType,
  });
  final String id;
  @override
  final String ticker;
  @override
  final String name;
  final String? subtype;
  final String? country;
  final String? error;
  @override
  final RemoteType remoteType;

  static CryptoModel fromJson(Map<String, dynamic> data) {
    final String category = data['category'] ?? 'Bourse';
    return CryptoModel(
      id: data['id'],
      ticker: data['ticker'],
      name: data['name'] ?? '',
      subtype: data['type'] ?? '',
      error:
          data['error'] != null
              ? 'Récupération automatique impossible sur ce type de données'
              : null,
      remoteType: category == 'Crypto' ? RemoteType.crypto : RemoteType.bourse,
    );
  }
}

class StockModel extends AssetModel {
  StockModel({
    required this.id,
    required this.ticker,
    required this.name,
    this.subtype,
    this.error,
    required this.remoteType,
  });

  final String id;
  @override
  final String ticker;
  @override
  final String name;
  final String? subtype;
  final String? error;
  @override
  final RemoteType remoteType;

  static StockModel fromJson(Map<String, dynamic> data) {
    final String category = data['category'] ?? 'Bourse';
    return StockModel(
      id: data['id'],
      ticker: data['ticker'],
      name: data['name'] ?? '',
      subtype: data['type'] ?? '',
      error:
          data['error'] != null
              ? 'Récupération automatique impossible sur ce type de données'
              : null,
      remoteType: category == 'Crypto' ? RemoteType.crypto : RemoteType.bourse,
    );
  }
}

class RealEstateModel {
  RealEstateModel({
    required this.id,
    required this.address,
    required this.type,
    required this.purpose,
  });

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

class CashModel {
  CashModel({
    required this.id,
    required this.bank,
    required this.account,
    required this.amount,
  });
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
