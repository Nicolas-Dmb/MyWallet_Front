import 'package:flutter/material.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool disable;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor:
            disable
                ? WidgetStateProperty.all(AppColors.interactive1)
                : WidgetStateProperty.all(AppColors.border1),
        foregroundColor:
            disable
                ? WidgetStateProperty.all(AppColors.interactive1)
                : WidgetStateProperty.all(AppColors.interactive3),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
      onPressed: disable ? null : onPressed,
      child: Text(text, style: AppTextStyles.text),
    );
  }
}
