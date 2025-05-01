import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
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
                    return _SelectedQuizzButton(
                      text: widget.question.answers[index],
                      onTap: (newValue) {
                        setState(() {
                          _controller.text = widget.question.answers[index];
                        });
                      },
                      isSelected:
                          _controller.text == widget.question.answers[index],
                    );
                  },
                );
              }
            },
          ),
        ];
      },
    );
  }
}
