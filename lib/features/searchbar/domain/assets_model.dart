import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';

abstract class AssetModel {
  static AssetModel fromJson(Map<String, dynamic> json, FilterType type) {
    switch (type) {
      case FilterType.bourse:
        return StockModel.fromJson(json);
      case FilterType.crypto:
        return CryptoModel.fromJson(json);
      case FilterType.immo:
        return RealEstateModel.fromJson(json);
      case FilterType.cash:
        return CashModel.fromJson(json);
      default:
        throw Exception('Type inconnu');
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
  });
  final String id;
  final String ticker;
  final String name;
  final String? subtype;
  final String? country;
  final String? error;

  static CryptoModel fromJson(Map<String, dynamic> data) {
    return CryptoModel(
      id: data['id'],
      ticker: data['ticker'],
      name: data['name'] ?? '',
      subtype: data['type'] ?? '',
      error:
          data['error'] != null
              ? 'Récupération automatique impossible sur ce type de données'
              : null,
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
  });

  final String id;
  final String ticker;
  final String name;
  final String? subtype;
  final String? error;

  static StockModel fromJson(Map<String, dynamic> data) {
    return StockModel(
      id: data['id'],
      ticker: data['ticker'],
      name: data['name'] ?? '',
      subtype: data['type'] ?? '',
      error:
          data['error'] != null
              ? 'Récupération automatique impossible sur ce type de données'
              : null,
    );
  }
}

class RealEstateModel extends AssetModel {
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

class CashModel extends AssetModel {
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
