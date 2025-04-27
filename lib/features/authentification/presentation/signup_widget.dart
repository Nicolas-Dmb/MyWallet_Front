import 'package:flutter/material.dart';
import 'package:mywallet_mobile/features/authentification/domain/service/auth_navigation_service.dart';
import 'package:mywallet_mobile/features/authentification/domain/usecases/signup_usecase.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/auth_navigation_controller.dart';
import 'package:mywallet_mobile/features/authentification/presentation/controller/signup_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';
import 'package:provider/provider.dart';
import 'package:mywallet_mobile/features/authentification/auth_di.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext contex) {
    return Provider(
      create: (context) => AuthNavigationController(NavigationService(context)),
      child: BlocProvider(
        create: (_) => SignupController(locator<SignupUseCase>()),
        child: Scaffold(
          appBar: CustomAppBar(title: 'Inscription', isLeading: true),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
            child: Center(child: _FormWidget()),
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          Text("Username", style: AppTextStyles.text),
          CustomTextForm(controller: _usernameController),
          SizedBox(height: 10),
          Text("Mot de passe", style: AppTextStyles.text),
          CustomTextForm(controller: _passwordController, isObscure: true),
          SizedBox(height: 10),
          Text("Confirmer le mot de passe", style: AppTextStyles.text),
          CustomTextForm(
            controller: _confirmPasswordController,
            isObscure: true,
          ),
          SizedBox(height: 20),
          _ErrorMessage(),
          Spacer(),
          _InputWidget(
            formKey: _formKey,
            emailController: _emailController,
            usernameController: _usernameController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
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
    return BlocBuilder<SignupController, SubmitState>(
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
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _InputWidget({
    required this.formKey,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    final navigationController = context.read<AuthNavigationController>();
    return BlocBuilder<SignupController, SubmitState>(
      builder: (context, state) {
        if (state is Initial || state is Error) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextButton(
                text: 'Créer un compte',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<SignupController>().submit(
                      emailController.text,
                      usernameController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                    );
                  }
                },
              ),
              SizedBox(height: 5),
              TextButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed:
                    () => context.read<AuthNavigationController>().goToLogin(),
                child: Text('Connexion', style: AppTextStyles.text),
              ),
            ],
          );
        } else if (state is Succes) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigationController.goToDashboard();
          });
          return SizedBox.shrink();
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
