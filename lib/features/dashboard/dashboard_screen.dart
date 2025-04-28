import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/widgets/components/floating_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingButton(
        text: "achat/vente",
        onTap: () => {context.push('/dashboard/trading')},
      ),
      body: Center(child: Text('Dashboard', style: AppTextStyles.title1)),
    );
  }
}
