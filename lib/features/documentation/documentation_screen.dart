import 'package:flutter/material.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Center(child: Text('Documentation', style: AppTextStyles.title1)),
    );
  }
}
