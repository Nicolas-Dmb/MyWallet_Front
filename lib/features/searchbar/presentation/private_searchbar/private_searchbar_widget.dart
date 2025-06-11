import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';
import 'package:mywallet_mobile/features/searchbar/domain/private_assets_model.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/private_searchbar/private_searchbar_controller.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_widget.dart';
import 'package:mywallet_mobile/features/searchbar/searchbar_screen.dart';

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
                    return AssetElement(
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
