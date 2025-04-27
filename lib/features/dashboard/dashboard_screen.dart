import 'package:flutter/material.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Center(child: Text('dashboard', style: AppTextStyles.title1)),
    );
  }
}
