import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext contex) {
    return GestureDetector(
      onTap: onTap, // << ton onPress ici
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.transparentButton,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(120),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(120),
          ),
        ),
        width: 120,
        height: 37,
        child: Center(child: Text('Achat/Vente', style: AppTextStyles.button)),
      ),
    );
  }
}
