import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'component/header.dart';
import 'component/lineChart.dart';
import 'component/tokenManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HoverView extends StatefulWidget{

    const HoverView ({Key ?key}):super(key:key);


    @override
    State<HoverView> createState() => _HoverViewState();
}

class _HoverViewState extends State<HoverView> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String? _accessToken;
  bool isReady = false;
  late Map<String, dynamic> colors;  

  @override
  void initState() {
    super.initState();
    loadColors();
  }
  
  // Future qui récupère les données de SharedPreferences
  Future<void> loadColors() async {
    final prefs = await SharedPreferences.getInstance();
    String? colorsString = prefs.getString('colors');
    if (colorsString != null && colorsString.isNotEmpty) {
        setState((){
            colors = jsonDecode(colorsString); // Retourner les couleurs
        });
    } else {
        setState((){
            colors = {
            'background1':'0xFF181111',
            'background2':'0xFF1F1513',
            'interactive1':'0xFF391714',
            'interactive2':'0xFF4E1511',
            'interactive3':'0xFF5E1C16',
            'border1':'0xFF6E2920',
            'border2':'0xFF853A2D',
            'border3':'0xFFAC4D39',
            'button1':'0xFFE54D2E',
            'button2':'0xFFEC6142',
            'text1':'0xFFFF977D',
            'text2':'0xFFFBD3CB',
            };
        }); // Valeur par défaut
        //je relance la page car au premier chargement les couleurs ne se chargent pas bien
        Future.delayed(Duration(seconds: 1), () {
            setState(() {
                Navigator.pushReplacementNamed(context, '/main');
            });
        });
    }
     setState(() {
        isReady = true; // Lancer l'initialisation après 1 seconde
    });
  }

  Future<void> checkAccessToken(BuildContext context) async {
    String? token = await storage.read(key: 'access_token');
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _accessToken = token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isReady
        ?
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFF181111),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          )
        :
        Scaffold(
            backgroundColor: Color(int.parse(colors['background1'])),
            body: Column(
                children: [
                    Header(isConnect: true),
                    Expanded(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // children: [
                        // LineChart()
                        // ],
                        ),
                    ),
                ],
            ),
        );
    }
}
