import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/features/searchbar/domain/assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/domain/searchbar_asset_service.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_controller.dart';

enum FilterType { bourse, crypto }

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
        SearchBarWidget(onPress: onPress, filter: filter);
      },
      leading: const Icon(Icons.search, color: AppColors.interactive3),
    );
  }
}

class SearchBarProviderWidget extends StatelessWidget {
  const SearchBarProviderWidget({
    super.key,
    required this.onPress,
    required this.filter,
  });
  final Function onPress;
  final FilterType filter;

  @override
  Widget build(BuildContext build) {
    return BlocProvider(
      create: (context) => SearchbarController(di<SearchbarAssetService>()),
      child: SearchBarWidget(onPress: onPress, filter: filter),
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
  final FilterType filter;
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
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: state.assets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _AssetElement(
                      value: state.assets[index],
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
  const _AssetElement({required this.value, required this.onPress});

  final AssetModel value;
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
                Text(value.name, style: AppTextStyles.title3),
                Text(value.ticker, style: AppTextStyles.italic),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
