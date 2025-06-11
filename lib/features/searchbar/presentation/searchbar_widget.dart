import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/features/searchbar/domain/private_assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/searchbar_asset_service.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/private_searchbar_controller.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_controller.dart';
import 'package:mywallet_mobile/features/trading/trading_barrel.dart';

enum AssetFilterType {
  bourse,
  crypto;

  static bool isAssetFilterType(FilterType type) {
    AssetFilterType.values.map((value) {
      if (value.name == type.name) {
        return true;
      }
    });
    return false;
  }

  static AssetFilterType fromFilterType(FilterType type) {
    return AssetFilterType.values.firstWhere(
      (value) => value.name == type.name,
    );
  }
}

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

enum PrivateFilterType {
  immo,
  cash;

  static bool isPrivateFilterType(FilterType type) {
    PrivateFilterType.values.map((value) {
      if (value.name == type.name) {
        return true;
      }
    });
    return false;
  }

  static PrivateFilterType fromFilterType(FilterType type) {
    return PrivateFilterType.values.firstWhere(
      (value) => value.name == type.name,
    );
  }
}

class FakeSearchBarWidget extends StatelessWidget {
  const FakeSearchBarWidget({
    super.key,
    required this.onPress,
    required this.filter,
  });

  final Function onPress;
  final FilterType filter;

  @override
  Widget build(BuildContext build) {
    return SearchBar(
      hintText: 'Recherche...',
      backgroundColor: WidgetStateProperty.all(AppColors.border3),
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onTap: () {
        if (AssetFilterType.isAssetFilterType(filter)) {
          SearchBarProviderWidget(
            onPress: onPress,
            filter: AssetFilterType.fromFilterType(filter),
          );
        } else {
          PrivateSearchBarProviderWidget(
            onPress: onPress,
            filter: PrivateFilterType.fromFilterType(filter),
          );
        }
      },
      leading: const Icon(Icons.search, color: AppColors.interactive3),
    );
  }
}

/// only for [PrivateFilterType]
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
      create: (context) => SearchbarController(di<SearchbarAssetService>()),
      child: SearchBarWidget(onPress: onPress, filter: filter),
    );
  }
}

class PrivateSearchBarWidget extends StatefulWidget {
  const PrivateSearchBarWidget({
    super.key,
    required this.onPress,
    required this.filter,
  });
  final Function onPress;
  final PrivateFilterType filter;

  @override
  State<PrivateSearchBarWidget> createState() => PrivateSearchBarWidgetState();
}

class PrivateSearchBarWidgetState extends State<PrivateSearchBarWidget> {
  SearchController controller = SearchController();

  @override
  void initState() {
    super.initState();
    controller.openView();
  }

  void setControllerText(PrivateAssetsModel asset) {
    if (asset is RealEstateModel) {
      controller.text = asset.address;
    } else if (asset is CashModel) {
      controller.text = "${asset.bank} - ${asset.account} - ${asset.amount}";
    }
    setState(() {});
  }

  String extractTitle(PrivateAssetsModel asset) {
    if (asset is RealEstateModel) {
      return asset.address;
    }
    final currentAsset = asset as CashModel;
    return currentAsset.bank;
  }

  String extractSubtext(PrivateAssetsModel asset) {
    if (asset is RealEstateModel) {
      return '${asset.purpose} - ${asset.type}';
    }
    final currentAsset = asset as CashModel;
    return '${currentAsset.account} - ${currentAsset.amount}';
  }

  @override
  Widget build(BuildContext build) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          hintText: 'Recherche...',
          backgroundColor: WidgetStateProperty.all(AppColors.border3),
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onChanged: (input) {
            controller.openView();
            context.read<PrivateSearchbarController>().search(input);
          },
          leading: const Icon(Icons.search, color: AppColors.interactive3),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return [
          BlocBuilder<PrivateSearchbarController, PrivateSearchbarState>(
            builder: (context, state) {
              if (state is PrivateSearchbarLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: state.assets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _AssetElement(
                      title: extractTitle(state.assetsFiltered[index]),
                      subtext: extractSubtext(state.assetsFiltered[index]),
                      onPress: () {
                        widget.onPress;
                        setControllerText(state.assetsFiltered[index]);
                      },
                    );
                  },
                );
              }
              if (state is PrivateSearchbarLoading ||
                  state is PrivateSearchbarInitialing) {
                return Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(color: AppColors.border1),
                  ),
                );
              }
              if (state is PrivateSearchbarError) {
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(75, 231, 218, 217),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(state.message, style: AppTextStyles.title3),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ];
      },
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.onPress,
    required this.filter,
  });
  final Function onPress;
  final AssetFilterType filter;
  @override
  State<SearchBarWidget> createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  SearchController controller = SearchController();

  @override
  void initState() {
    super.initState();
    controller.openView();
  }

  @override
  Widget build(BuildContext build) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          hintText: 'Recherche...',
          backgroundColor: WidgetStateProperty.all(AppColors.border3),
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onChanged: (input) {
            controller.openView();
            context.read<SearchbarController>().search(input, widget.filter);
          },
          leading: const Icon(Icons.search, color: AppColors.interactive3),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return [
          BlocBuilder<SearchbarController, SearchbarState>(
            builder: (context, state) {
              if (state is AssetLoaded) {
                return Column(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: state.assets.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _AssetElement(
                          title: state.assets[index].name,
                          subtext: state.assets[index].ticker,
                          onPress: () {
                            widget.onPress;
                            context.read<SearchbarController>().select(
                              state.assets[index],
                            );
                            setState(() {
                              controller.text =
                                  "${state.assets[index].name} - ${state.assets[index].ticker}";
                            });
                          },
                        );
                      },
                    ),
                    state.page == 2
                        ? SizedBox.shrink()
                        : _AssetElement(
                          title: 'Plus de résultat...',
                          subtext: '',
                          onPress: () {
                            context.read<SearchbarController>().retrieve(
                              controller.text,
                              widget.filter,
                            );
                          },
                        ),
                  ],
                );
              }
              if (state is Loading) {
                return Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(color: AppColors.border1),
                  ),
                );
              }
              if (state is Error) {
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(75, 231, 218, 217),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(state.message, style: AppTextStyles.title3),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ];
      },
    );
  }
}

class _AssetElement extends StatelessWidget {
  const _AssetElement({
    required this.title,
    required this.subtext,
    required this.onPress,
  });

  final String title;
  final String subtext;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(75, 231, 218, 217),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title3),
                Text(subtext, style: AppTextStyles.italic),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
