import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_app_bar.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/login_usecase.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/login_controller.dart';
import 'package:mywallet_mobile/features/welcome/presentation/welcome_controller.dart';
import 'package:mywallet_mobile/features/welcome/service/navigation_service.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => NavigationController(NavigationService(context)),
      child: BlocProvider(
        create: (_) => LoginController(locator<LoginUseCase>()),
        child: Scaffold(
          backgroundColor: AppColors.background1,
          appBar: CustomAppBar(title: 'Connexion', isLeading: true),
        ),
      ),
    );
  }
}
