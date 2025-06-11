import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/fake_searchbar_widget.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/private_searchbar/private_searchbar_controller.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/private_searchbar/private_searchbar_widget.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_controller.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';

enum AssetFilterType {
  bourse,
  crypto;

  static bool isAssetFilterType(FilterType type) {
    return AssetFilterType.values.any((value) => value.name == type.name);
  }

  static AssetFilterType fromFilterType(FilterType type) {
    return AssetFilterType.values.firstWhere(
      (value) => value.name == type.name,
    );
  }
}

enum PrivateFilterType {
  immo,
  cash;

  static bool isPrivateFilterType(FilterType type) {
    return PrivateFilterType.values.any((value) => value.name == type.name);
  }

  static PrivateFilterType fromFilterType(FilterType type) {
    return PrivateFilterType.values.firstWhere(
      (value) => value.name == type.name,
    );
  }
}

class SearchBarParams {
  final Function onPress;
  final FilterType filter;

  const SearchBarParams({required this.onPress, required this.filter});
}

class SearchBarScreen extends StatelessWidget {
  const SearchBarScreen({
    super.key,
    required this.onPress,
    required this.filter,
  });

  final Function onPress;
  final FilterType filter;
  @override
  Widget build(BuildContext context) {
    if (AssetFilterType.isAssetFilterType(filter)) {
      return SearchBarProviderWidget(
        onPress: onPress,
        filter: AssetFilterType.fromFilterType(filter),
      );
    } else {
      return PrivateSearchBarProviderWidget(
        onPress: onPress,
        filter: PrivateFilterType.fromFilterType(filter),
      );
    }
  }
}

/// only for [AssetFilterType]
class SearchBarProviderWidget extends StatelessWidget {
  const SearchBarProviderWidget({
    super.key,
    required this.onPress,
    required this.filter,
  });
  final Function onPress;
  final AssetFilterType filter;

  @override
  Widget build(BuildContext build) {
    return BlocProvider(
      create: (context) => SearchbarController.inject(),
      child: SearchBarWidget(onPress: onPress, filter: filter),
    );
  }
}

/// only for [PrivateFilterType], immo & cash
class PrivateSearchBarProviderWidget extends StatelessWidget {
  const PrivateSearchBarProviderWidget({
    super.key,
    required this.onPress,
    required this.filter,
  });
  final Function onPress;
  final PrivateFilterType filter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivateSearchbarController.inject(filter),
      child: PrivateSearchBarWidget(onPress: onPress, filter: filter),
    );
  }
}
