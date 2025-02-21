import 'package:flutter/material.dart';
import 'package:mywallet_mobile/authentification/presentation/controller/signup_controller.dart';
import 'package:mywallet_mobile/core/theme/app_fonts.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_app_bar.dart';
import 'package:mywallet_mobile/core/widgets/components/custom_text_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignupWidget extends StatelessWidget{
  const SignupWidget({super.key})

  @override
  Widget build(BuildContext contex){
    return BlocProvider(
      create: (_) => SignupController(),
      child: Scaffold(
      appBar:CustomAppBar(title: 'Inscription', isLeading: true),
      body:Padding(
        padding:EdgeInsets.symmetric(
          horizontal:70,
          vertical:30 ),
        child: Center(
          child:Column(
            children:[
              Spacer(),
              _FormWidget(),
           ],
        ),
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
class _FormWidgetState extends State< _FormWidget>{
  final _formKey = GlobalKey<FormState>();

  String? email; 
  String? username;
  String? password;
  String? confirmPassword;

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
            Text("Email", style:AppTextStyles.text),
            CustomTextForm(onChangedValue: (value) {
              setState(() {
                email = value;
              });
            }),
            SizedBox(height:10),
            Text("Username", style:AppTextStyles.text),
            CustomTextForm(onChangedValue: (value) {
              setState(() {
                username = value;
              });
            }),
            SizedBox(height:10),
            Text("Mot de passe", style:AppTextStyles.text),
            CustomTextForm(onChangedValue: (value) {
              setState(() {
                password = value;
              });
            }),
            SizedBox(height:10),
            Text("Confirmer le mot de passe", style:AppTextStyles.text),
            CustomTextForm(onChangedValue: (value) {
              setState(() {
                confirmPassword = value;
              });
            }),
            SizedBox(height:50),
            _ErrorMessage(),
            Spacer(),
            _InputWidget(),
            SizedBox(height:20),
        ],
      ),
    );
  }
}
class _ErrorMessage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return BlocListener<SignupController, SubmitState>(
      listener:(context, state){
        if(state is Error){
          Text(state.errorMessage, style:AppTextStyles.error);
        }
      }
    );
  }
}
class _InputWidget extends StatelessWidget{

}