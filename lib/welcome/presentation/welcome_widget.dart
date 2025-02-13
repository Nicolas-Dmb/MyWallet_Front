import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      appBar: AppBar(
          title: const Text(
        'Welcome',
        style: AppTextStyles.title1,
      )),
      body: const _WelcomeBody(),
    );
  }
}

class _WelcomeBody extends StatelessWidget {
  const _WelcomeBody();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const Spacer(),
      SvgPicture.asset('assets/images/wallet.svg'),
      const Spacer(),
      const _ContinuerButton(),
      const SizedBox(height: 98)
    ]));
  }
}

class _ContinuerButton extends StatelessWidget {
  const _ContinuerButton();

  @override
  Widget build(BuildContext contex) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.border1),
          foregroundColor: WidgetStateProperty.all(AppColors.interactive3),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ))),
      onPressed: () {},
      child: const Text(
        'TextButton',
        style: AppTextStyles.text,
      ),
    );
  }
}
