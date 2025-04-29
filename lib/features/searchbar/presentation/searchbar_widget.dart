import 'package:flutter/material.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';

enum FilterType { bourse, crypto, immo, cash, all }

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.onPress,
    required this.filter,
  });

  final Function onPress;
  final FilterType filter;
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
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search, color: AppColors.interactive3),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              //
            },
          );
        });
      },
    );
  }
}
