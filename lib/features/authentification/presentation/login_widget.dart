import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:mywallet_mobile/core/di.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';
import 'package:mywallet_mobile/features/authentification/presentation/custom_app_bar.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_text_button.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_input_form.dart';
import 'package:mywallet_mobile/features/authentification/domain/service/auth_navigation_service.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/login_usecase.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/login_controller.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/auth_navigation_controller.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthNavigationController(NavigationService(context)),
      child: BlocProvider(
        create: (_) => LoginController(di<LoginUseCase>(), di<AuthService>()),
        child: Scaffold(
          backgroundColor: AppColors.background1,
          appBar: CustomAppBar(title: 'Connexion', isLeading: true),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
            child: _FormWidget(),
          ),
        ),
      ),
    );
  }
}

class _FormWidget extends StatefulWidget {
  @override
  State<_FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Spacer(),
          Text("Email", style: AppTextStyles.text),
          CustomTextForm(controller: _emailController),
          SizedBox(height: 10),
          Text("Mot de passe", style: AppTextStyles.text),
          CustomTextForm(controller: _passwordController, isObscure: true),
          SizedBox(height: 20),
          _ErrorMessage(),
          Spacer(),
          _InputWidget(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginController, LoginState>(
      builder: (context, state) {
        if (state is Error) {
          return Text(state.error.message, style: AppTextStyles.error);
        }
        return SizedBox.shrink();
      },
    );
  }
}

class _InputWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _InputWidget({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final navigationController = context.read<AuthNavigationController>();
    return BlocBuilder<LoginController, LoginState>(
      builder: (context, state) {
        if (state is Initial || state is Error) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthNavigationController>().goToSignup();
                  }
                },
                child: Text('Créer un compte', style: AppTextStyles.text),
              ),
              SizedBox(height: 5),
              CustomTextButton(
                onPressed:
                    () => context.read<LoginController>().login(
                      emailController.text,
                      passwordController.text,
                      navigationController,
                    ),
                text: 'Connexion',
              ),
            ],
          );
        } else {
          return SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(color: AppColors.border1),
          );
        }
      },
    );
  }
}
