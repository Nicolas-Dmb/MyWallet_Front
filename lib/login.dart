import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'component/header.dart';
import 'component/tokenManager.dart';
import 'component/getSetting.dart';

/*
Mise en page terminé mais
beug sur les appels API
Verifier les verifs coté front a la saisie des input */
class Login extends StatelessWidget {
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(isConnect: false),
            const Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: LoginForm(),
                ),
              ),
            ),
          ],
        ),
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
  final TokenManager tokenManager = TokenManager();
  final GetSettingAccount settings = GetSettingAccount();
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  //Pour se connecter
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //Pour créer un compte
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPWController = TextEditingController();
  //Pour envoyer aux API
  bool _isLoading = false;
  String? _responseMessage;
  bool hiddenPassword = true;
  bool isAccount = true;

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _responseMessage = null;
      });

      final url = Uri.parse(
          'https://mywalletapi-502906a76c4f.herokuapp.com/api/token/');

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
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
          const storage = FlutterSecureStorage();
          await storage.write(
              key: 'access_token', value: responseData["access"]);
          await storage.write(
              key: 'refresh_token', value: responseData["refresh"]);
          tokenManager.startTokenRenewal();
          await settings.initialize();
          if (mounted) {
            navigateTo(context, '/main');
          }
        } else {
          setState(() {
            _responseMessage = 'Erreur: ${response.statusCode}';
          });
        }
      } catch (error) {
        setState(() {
          _responseMessage =
              'Erreur : Une erreur est survenue. Veuillez réessayer plus tard.${error}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signUpForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _responseMessage = null;
      });

      final url =
          Uri.parse('https://mywalletapi-502906a76c4f.herokuapp.com/api/user/');

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            "first_name": _firstNameController.text,
            "last_name": _lastNameController.text,
            "username": _usernameController.text,
            'email': _emailController.text,
            "phone": _phoneController.text,
            'password': _passwordController.text,
            "confirm_password": _confirmPWController.text,
          }),
        );
        final responseData = json.decode(response.body);
        if (response.statusCode == 201) {
          setState(() {
            _responseMessage =
                responseData['message'] ?? 'Compte créé avec succès!';
            isAccount = true;
          });
        } else {
          setState(() {
            _responseMessage =
                responseData['message'] ?? 'Erreur ${response.statusCode}';
          });
        }
      } catch (error) {
        setState(() {
          _responseMessage =
              "Erreur  : une erreur s'est produite lors de la création du compte  / ${error}";
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
        horizontal: MediaQuery.of(context).size.width < 700
            ? MediaQuery.of(context).size.width * 0.05
            : MediaQuery.of(context).size.width * 0.30,
        vertical: isAccount
            ? MediaQuery.of(context).size.height * 0.3
            : MediaQuery.of(context).size.height * 0.2,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Question si on a pas sur SignUp
            if (isAccount == false) ...[
              TextFormField(
                controller: _firstNameController,
                style: const TextStyle(color: Color(0xFFFBD3CB)),
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre Prénom';
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextFormField(
                controller: _lastNameController,
                style: const TextStyle(color: Color(0xFFFBD3CB)),
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre Nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(color: Color(0xFFFBD3CB)),
                decoration: const InputDecoration(labelText: 'Identifiant'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre Identifiant';
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextFormField(
                controller: _phoneController,
                style: const TextStyle(color: Color(0xFFFBD3CB)),
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre Téléphone';
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
            TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Color(0xFFFBD3CB)),
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre Email';
                } else if (isAccount == false &&
                    !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                  return 'Veuillez retourner un Email valide';
                }
                return null;
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            TextFormField(
              controller: _passwordController,
              style: const TextStyle(color: Color(0xFFFBD3CB)),
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
                } else if (value.length < 8 && isAccount == false) {
                  return 'Le mot de passe doit contenir plus de 8 caractères';
                } else if (!RegExp(r'[0-9]').hasMatch(value) &&
                    isAccount == false) {
                  return 'Le mot de passe doit contenir au moins un chiffre';
                } else if (!RegExp(r'[A-Z]').hasMatch(value) &&
                    !RegExp(r'[a-z]').hasMatch(value) &&
                    isAccount == false) {
                  return 'Le mot de passe doit contenir au moins une Majuscule et une Minuscule';
                } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value) &&
                    isAccount == false) {
                  return 'Le mot de passe doit au moins contenir un caractère spéciale';
                }
                return null;
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            if (isAccount == false) ...[
              TextFormField(
                controller: _confirmPWController,
                style: const TextStyle(color: Color(0xFFFBD3CB)),
                decoration: InputDecoration(
                  labelText: 'Mot de passe de confirmation',
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
                    return 'Veuillez entrer votre mot de passe de confirmation';
                  }
                  if (value != _passwordController.text) {
                    return 'Mot de passe différent';
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: isAccount ? _loginForm : _signUpForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E1C16),
                      foregroundColor: const Color(0xFFFF977D),
                      overlayColor: const Color(0xFF391714),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Envoyer'),
                  ),
            if (_responseMessage != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _responseMessage!,
                  style: TextStyle(
                    color: _responseMessage!.startsWith('Erreur')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            ],

            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFF977D),
                overlayColor: const Color(0xFFEC6142),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  isAccount = !isAccount;
                });
              },
              child: isAccount
                  ? const Text("Créer un compte")
                  : const Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
