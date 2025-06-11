import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/features/searchbar/searchbar_screen.dart';
import 'package:mywallet_mobile/features/trading/trading_barrel.dart';

enum FilterType {
  bourse,
  crypto,
  immo,
  cash;

  static FilterType fromAssetType(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return FilterType.bourse;
      case AssetType.crypto:
        return FilterType.crypto;
      case AssetType.cash:
        return FilterType.immo;
      case AssetType.realEstate:
        return FilterType.cash;
    }
  }
}

class FakeSearchBarWidget extends StatelessWidget {
  const FakeSearchBarWidget({
    super.key,
    required this.onPress,
    required this.filter,
    this.text,
  });

  final String? text;
  final Function onPress;
  final FilterType filter;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: text ?? 'Recherche...',
      backgroundColor: WidgetStateProperty.all(AppColors.border3),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onTap:
          () => context.push(
            '/searchbar',
            extra: SearchBarParams(onPress: onPress, filter: filter),
          ),
      leading: const Icon(Icons.search, color: AppColors.interactive3),
    );
  }
}
