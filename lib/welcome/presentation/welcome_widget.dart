import 'package:flutter/material.dart';
import 'package:mywallet_mobile/welcome/presentation/welcome_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_app_bar.dart';
import 'package:mywallet_mobile/welcome/service/navigation_service.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => NavigationController(NavigationService(context)),
      child: Scaffold(
        backgroundColor: AppColors.background1,
        appBar: CustomAppBar(title: 'My Wallet', isLeading: false),
        body: const _WelcomeBody(),
      ),
    );
  }
}

class _WelcomeBody extends StatelessWidget {
  const _WelcomeBody();

  @override
  Widget build(BuildContext context) {
    final navigationController = context.read<NavigationController>();
    return Center(
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            'lib/welcome/presentation/assets/images/wallet.svg',
            width: MediaQuery.of(context).size.width * 0.80,
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ContinuerButton(
                  title: 'Connexion',
                  onPressed: navigationController.navigateToLogin,
                ),
                Spacer(),
                _ContinuerButton(
                  title: 'Inscription',
                  onPressed: navigationController.navigateToSignUp,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ContinuerButton extends StatelessWidget {
  const _ContinuerButton({required this.title, required this.onPressed});
  final VoidCallback onPressed;
  final String title;
  @override
  Widget build(BuildContext contex) {
    return SizedBox(
      width: 120,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.border1),
          foregroundColor: WidgetStateProperty.all(AppColors.interactive3),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
        onPressed: onPressed,
        child: Text(title, style: AppTextStyles.text),
      ),
    );
  }
}
