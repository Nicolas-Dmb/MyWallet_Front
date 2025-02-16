import 'package:flutter/material.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/widgets/custom_app_bar.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      appBar: CustomAppBar(title: 'Connexion', isLeading: true),
    );
  }
}
