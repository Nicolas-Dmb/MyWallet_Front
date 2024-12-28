import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'component/header.dart';
import 'component/lineChart.dart';
import 'component/tokenManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component/getSetting.dart';

class HoverView extends StatefulWidget{

    const HoverView ({Key ?key}):super(key:key);


    @override
    State<HoverView> createState() => _HoverViewState();
}

class _HoverViewState extends State<HoverView>{
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? _accessToken;
    final GetSettingAccount settings = GetSettingAccount();
    //late SharedPreferences prefs;

    //Init 
    @override
    void initState() {
        super.initState();
        initializeSettings();
    }

    Future<void> initializeSettings() async {
        // Initialiser SharedPreferences via votre classe
        await settings.initialize();
        final prefs = await SharedPreferences.getInstance();
        print('username ${prefs.getString('username')}');
        print('email ${prefs.getString('email')}');
        print('nightMode ${prefs.getString('nightMode')}');
    }

    //vérifier si l'user est connecté
    Future<void> checkAccessToken(BuildContext context) async {
        String? token = await storage.read(key: 'access_token');
        if (token == null || token.isEmpty) {
        // Si le token n'existe pas, redirige vers la page de connexion
        Navigator.pushReplacementNamed(context, '/');
        }
        else{
            _accessToken=token;
        }
    }
    
    //Récupérer son historique wallet


    //Récupérer ses actifs favoris 


    //Récupérer la répartition de son PF

    @override
    Widget build(BuildContext context){
        return Scaffold(
            backgroundColor : Color(0xFF181111),
            body : Column(
                children: [
                    Header(isConnect: true),
                    Expanded(
                        child : Row(
                            mainAxisAlignment : MainAxisAlignment.spaceBetween,
                            //children : [
                                //LineChart()
                            //],
                        ),
                    ),
                ],
            ),
        );
    }
}