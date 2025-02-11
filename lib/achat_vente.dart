import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'component/header.dart';
import 'component/getSetting.dart';
import 'component/bourseForm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchatVente extends StatelessWidget {
  const AchatVente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(children: [
              Container(
                padding: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.height < 685
                        ? MediaQuery.of(context).size.height * 0.15
                        : MediaQuery.of(context).size.height * 0.1)),
                height: MediaQuery.of(context)
                    .size
                    .height, // Utiliser la hauteur de l'écran
                child: const SingleChildScrollView(
                  child: Column(
                    children: [
                      //SizedBox(height: 150),  // Espace pour le header
                      AchatVenteForm(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Header(isConnect: true),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class AchatVenteForm extends StatefulWidget {
  const AchatVenteForm({
    super.key,
  });

  @override
  State<AchatVenteForm> createState() => _AchatVenteState();
}

class _AchatVenteState extends State<AchatVenteForm> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final GetSettingAccount settings = GetSettingAccount();
  String? _accessToken;
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  String? _id;
  bool isReady = false;
  String? _currency;
  late Map<String, dynamic> colors;
  final List<String> listAssets = <String>[
    'Bourse',
    'Cryptomonnaie',
    'Immobilier'
  ];

  //input
  bool _isSell = false;
  String? _typeAsset = 'Bourse';

  @override
  void initState() {
    super.initState();
    checkAccessToken(context);
    initializeSettings();
  }

  Future<void> initializeSettings() async {
    // Initialiser SharedPreferences via votre classex
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      colors = jsonDecode(prefs.getString('colors').toString() ?? '');
      _id = prefs.getString('userId').toString() ?? '';
      _currency = prefs.getString('devise').toString() ?? '';
      isReady = true;
    });
  }

  //Vérifier que le token est présent
  Future<void> checkAccessToken(BuildContext context) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      // Si le token n'existe pas, redirige vers la page de connexion
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _accessToken = token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isReady
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFF181111),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: const CircularProgressIndicator(),
                ),
              ],
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height*0.2,
            color: Color(int.parse(colors['background1'])),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isSell = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSell
                              ? Color(int.parse(colors['interactive3']))
                              : Color(int.parse(colors['button1'])),
                          foregroundColor: _isSell
                              ? Color(int.parse(colors['text1']))
                              : Color(int.parse(colors['text2'])),
                          overlayColor:
                              Color(int.parse(colors['interactive1'])),
                          fixedSize: MediaQuery.of(context).size.width > 900
                              ? Size(MediaQuery.of(context).size.width * 0.1,
                                  MediaQuery.of(context).size.height * 0.1)
                              : Size(MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.1),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text('Achat'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isSell = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_isSell
                              ? Color(int.parse(colors['interactive3']))
                              : Color(int.parse(colors['button1'])),
                          foregroundColor: !_isSell
                              ? Color(int.parse(colors['text1']))
                              : Color(int.parse(colors['text2'])),
                          overlayColor:
                              Color(int.parse(colors['interactive1'])),
                          fixedSize: MediaQuery.of(context).size.width > 900
                              ? Size(MediaQuery.of(context).size.width * 0.1,
                                  MediaQuery.of(context).size.height * 0.1)
                              : Size(MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.1),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text('Vente'),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text("Type d'actif :",
                      style:
                          TextStyle(color: Color(int.parse(colors['text1'])))),
                  DropdownButton<String>(
                    value: _typeAsset,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: TextStyle(
                        color: Color(int.parse(colors['interactive3']))),
                    /*underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                        ),*/
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        _typeAsset = value;
                      });
                    },
                    items: listAssets
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                                color: Color(int.parse(colors['text1'])))),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  BourseForm(isSell: _isSell),
                ],
              ),
            ),
          );
  }
}
