import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.isLeading,
    this.onTap,
    this.buttonText,
  });
  final String title;
  final bool isLeading;
  final VoidCallback? onTap;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background1,
      title: Text(title, style: AppTextStyles.title1),
      toolbarHeight: 100,
      centerTitle: true,
      leading:
          isLeading
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.background2,
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      AppColors.interactive3,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  onPressed: () => onTap ?? context.pop(),
                  child: Text(
                    buttonText ?? 'retour',
                    style: AppTextStyles.small,
                  ),
                ),
              )
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
