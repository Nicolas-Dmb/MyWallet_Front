import 'package:flutter/material.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';

class CustomTextForm extends StatelessWidget {
  final ValueChanged<String>? onChangedValue;
  const CustomTextForm({super.key, required this.onChangedValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChangedValue,
      style: AppTextStyles.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.border1,
        focusColor: AppColors.interactive3,
      ),
    );
  }
}
