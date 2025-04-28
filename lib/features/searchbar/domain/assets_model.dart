class AssetsModel {
  AssetsModel({
    required this.ticker,
    required this.company,
    this.subtype,
    this.country,
    this.error,
  });

  final String ticker;
  final String company;
  final String? subtype;
  final String? country;
  final String? error;

  static AssetsModel fromJson(Map<String, String> data, String error) {
    return AssetsModel(
      ticker: data['ticker'] ?? '',
      company: data['company'] ?? '',
      subtype: data['type'] ?? '',
      country: data['country'] ?? '',
      error: data['error'] != null ? error : '',
    );
  }
}
