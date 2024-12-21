import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'component/header.dart';
import 'component/lineChart.dart';
import 'component/tokenManager.dart';

class HoverView extends StatefulWidget{

    const HoverView ({Key ?key}):super(key:key);


    @override
    State<HoverView> createState() => _HoverViewState();
}

class _HoverViewState extends State<HoverView>{
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? _accessToken;

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