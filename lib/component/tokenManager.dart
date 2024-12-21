import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager{
    Timer? _timer;
    final FlutterSecureStorage storage = FlutterSecureStorage();
    /*void navigateTo(String routeName) {
        Navigator.pushNamed(routeName);
    }*/

    void startTokenRenewal(){
        _timer = Timer.periodic(Duration(minutes: 4), (_) async{
        await refreshAccessToken();
        });
    }

    void stopTokenRenewal(){
        _timer?.cancel();
        storage.deleteAll();
    }

    Future<void> refreshAccessToken() async{
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/token/refresh/");

        try {
            final response = await http.post(
                url,
                headers:{
                    'Content-Type': 'application/json',
                },
                body : json.encode({
                    'refresh': await storage.read(key: 'refresh_token'),
                }),

            );
            if(response.statusCode == 200){
                final responseData = json.decode(response.body);
                await storage.write(key: 'access_token', value: responseData["access"]);
            }else{
                //print("Renouvellement de la connexion impossible");
                await storage.deleteAll();
                stopTokenRenewal();
                //navigateTo('/');
            }
        } catch(error){
            //print('Une erreur est survenue lors du renouvellement du token : ${error}');
            await storage.deleteAll();
            stopTokenRenewal();
        };
    }
}

