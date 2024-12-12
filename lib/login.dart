import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'component/header.dart';

class Login extends StatelessWidget {
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(isConnect: false),
          Expanded(
            child: Center(
              child: LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _StateLoginForm();
}

class _StateLoginForm extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _responseMessage;
  bool hiddenPassword = true;
  bool isAccount = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _responseMessage = null;
      });

      final url = Uri.parse('http://127.0.0.1:8000/api/token/');

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            _responseMessage = responseData['message'] ?? 'Succès!';
          });
        } else {
          setState(() {
            _responseMessage = 'Erreur: ${response.statusCode}';
          });
        }
      } catch (error) {
        setState(() {
          _responseMessage = 'Une erreur est survenue. Veuillez réessayer plus tard.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF181111),
      padding: EdgeInsets.symmetric(
        horizontal:MediaQuery.of(context).size.width < 700 ? MediaQuery.of(context).size.width*0.05:MediaQuery.of(context).size.width*0.30,
        vertical:MediaQuery.of(context).size.height*0.2,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre Email';
                }
                return null;
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                suffixIcon: IconButton(
                  icon: Icon(
                    hiddenPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      hiddenPassword = !hiddenPassword;
                    });
                  },
                ),
              ),
              obscureText: hiddenPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Envoyer'),
                    style :ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEC6142), 
                        foregroundColor: const Color(0xFFFF977D),
                        overlayColor: const Color(0xFFE54D2E), 
                        textStyle: const TextStyle( 
                        fontWeight: FontWeight.bold,
                        ),),
                ),

            if (_responseMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _responseMessage!,
                  style: TextStyle(
                    color: _responseMessage!.startsWith('Erreur') ? Colors.red : Colors.green,
                  ),
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFF977D), 
                    overlayColor: const Color(0xFFEC6142), 
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                    ),
                ),
                onPressed:(){
                    setState((){
                        isAccount = !isAccount;
                    });
                },
                child: isAccount? Text("Créer un compte"):Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
