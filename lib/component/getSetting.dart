import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class GetSettingAccount{
    final FlutterSecureStorage storage = FlutterSecureStorage();
    late SharedPreferences prefs;
    String? _accessToken;

    //initialisition de SharedPreferences 
    Future<void> initialize() async {
        prefs = await SharedPreferences.getInstance();
        await checkAccessToken().then((_) {
            if (_accessToken != null) {
                getSetting();
            }
        });
    }
    //Vérifier que le token est présent
    Future<void> checkAccessToken() async {
        String? token = await storage.read(key: 'access_token');
        _accessToken=token;
    }

    //Call Setting data
    Future<void> getSetting() async {
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/user/");
        try{
            final response = await http.get(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
            );
            if (response.statusCode==200){
                final List<dynamic> responseData = json.decode(response.body);

                if (responseData.isNotEmpty) {
                    final userData = responseData[0]; // Récupère le premier élément
                    print('username dans getSetting: ${userData['username']?.toString() ?? 'error'}');
                    await prefs.setString('username', userData['username']?.toString() ?? 'error');
                    await prefs.setString('email', userData['email']?.toString()?? 'error');
                    await prefs.setString('userId', userData['setting']['user']?.toString()?? 'error');
                    await prefs.setString('color', userData['setting']['color']?.toString()?? 'error');
                    await prefs.setString('devise', userData['setting']['currency']?.toString()?? 'error');
                    await prefs.setString('nightMode', userData['setting']['nightMode']?.toString()?? 'error');
                }
                print('passage ici');
            }
        }catch (e){
            await prefs.setString('username', 'error');
            await prefs.setString('email',  'error');
            await prefs.setString('userId', 'error');
            await prefs.setString('color', 'error');
            await prefs.setString('devise', 'error');
            await prefs.setString('nightMode', 'error');
        }
    }
}