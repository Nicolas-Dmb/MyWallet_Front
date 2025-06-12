import 'package:mywallet_mobile/features/searchbar/searchbar_screen.dart';

enum RemoteType { bourse, crypto }

abstract class AssetModel {
  RemoteType get remoteType;
  String get name;
  String get ticker;
  String get id;
  static AssetModel fromJson(Map<String, dynamic> json, AssetFilterType type) {
    switch (type) {
      case AssetFilterType.bourse:
        return StockModel.fromJson(json);
      case AssetFilterType.crypto:
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
  @override
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
  @override
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
