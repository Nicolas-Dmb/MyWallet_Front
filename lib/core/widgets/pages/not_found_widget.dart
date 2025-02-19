import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_app_bar.dart';

class NotFoundScreen extends StatefulWidget {
  final String previousRoute;

  const NotFoundScreen({super.key, required this.previousRoute});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(widget.previousRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      appBar: CustomAppBar(title: '', isLeading: false),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text("404 Not Found", style: AppTextStyles.title3),
              Spacer(),
              Text("Page en cours de création.", style: AppTextStyles.text),
              SizedBox(height: 10),
              SvgPicture.asset(
                'lib/core/widgets/pages/assets/builder-svgrepo-com.svg',
                width: MediaQuery.of(context).size.width * 0.50,
              ),
              Spacer(),
              Text("Vous allez être redirigé...", style: AppTextStyles.text),
              CircularProgressIndicator(color: AppColors.interactive3),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
