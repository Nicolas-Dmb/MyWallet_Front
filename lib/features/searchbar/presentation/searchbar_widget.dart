import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';
import 'package:mywallet_mobile/features/searchbar/presentation/searchbar_controller.dart';
import 'package:mywallet_mobile/features/searchbar/searchbar_screen.dart';

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
  }

  @override
  Widget build(BuildContext build) {
    return SearchAnchor(
      searchController: controller,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          hintText: 'Recherche...',
          backgroundColor: WidgetStateProperty.all(AppColors.border3),
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (input) {
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: state.assets.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AssetElement(
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
                            controller.closeView(null);
                          },
                        );
                      },
                    ),
                    state.page == 2
                        ? SizedBox.shrink()
                        : AssetElement(
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

class AssetElement extends StatelessWidget {
  const AssetElement({
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
