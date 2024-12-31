import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'component/header.dart';
import 'component/tokenManager.dart';
import 'component/getSetting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchatVente extends StatelessWidget{
    AchatVente({super.key});

    @override
    Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
        children: [
        Header(isConnect: true),
        Expanded(
            child: SingleChildScrollView(
            child: Column(
                children: [
                    AchatVenteForm(),
                ],
            ),
            ),
        ),
        ],
    ),
    );
    }
}

class AchatVenteForm extends StatefulWidget{
    AchatVenteForm({super.key,});

    @override
    State<AchatVenteForm> createState() => _AchatVenteState();
}

class _AchatVenteState extends State<AchatVenteForm>{
    final FlutterSecureStorage storage = FlutterSecureStorage();
    final GetSettingAccount settings = GetSettingAccount();
    String? _accessToken;
    final _formKey = GlobalKey<FormState>();
    String? _errorMessage; 
    String? _id;
    bool isReady = false;
    late Map<String, dynamic> colors;  
    final List<String> listAssets = <String>['Bourse','Cryptomonnaie','Immobilier'];

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
        setState((){
            colors = jsonDecode(prefs.getString('colors').toString()??'');
            _id = prefs.getString('userId').toString()??'';
            isReady = true;
        });
    }
    //Vérifier que le token est présent
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

    Widget build(BuildContext context){
        return !isReady ? 
        Container( 
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color:Color(0xFF181111),
                child: Row(
                    mainAxisAlignment : MainAxisAlignment.center,
                    children:[
                        Container(
                            width : MediaQuery.of(context).size.width*0.1,
                            height: MediaQuery.of(context).size.height*0.1,
                            child: CircularProgressIndicator(),
                        ),
                    ],
                ),
        ) :
        Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height*0.2,
            color :Color(int.parse(colors['background1'])),
            child : Column(
                children:[
                    SizedBox(height:MediaQuery.of(context).size.height*0.1),
                    Row(
                        mainAxisAlignment : MainAxisAlignment.center,
                        children:[
                            ElevatedButton(
                                onPressed: () {
                                    setState(() {
                                        _isSell = false;
                                    });
                                },
                                child: const Text('Achat'),
                                style :ElevatedButton.styleFrom(
                                    backgroundColor: _isSell ? Color(int.parse(colors['interactive3'])): Color(int.parse(colors['button1'])), 
                                    foregroundColor: _isSell ? Color(int.parse(colors['text1'])):Color(int.parse(colors['text2'])), 
                                    overlayColor: Color(int.parse(colors['interactive1'])),
                                    fixedSize:Size(MediaQuery.of(context).size.width*0.1,MediaQuery.of(context).size.height*0.1),
                                    textStyle: const TextStyle( 
                                        fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                    ),
                                ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                    setState(() {
                                        _isSell = true;
                                    });
                                },
                                child: const Text('Vente'),
                                style :ElevatedButton.styleFrom(
                                    backgroundColor: !_isSell ? Color(int.parse(colors['interactive3'])): Color(int.parse(colors['button1'])), 
                                    foregroundColor: !_isSell ? Color(int.parse(colors['text1'])):Color(int.parse(colors['text2'])), 
                                    overlayColor: Color(int.parse(colors['interactive1'])),
                                    textStyle: const TextStyle( 
                                        fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                    ),
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.1),
                    Text("Type d'actif :",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                    DropdownButton<String>(
                        value: _typeAsset,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: TextStyle(color:Color(int.parse(colors['interactive3']))),
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
                        items: listAssets.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                            );
                        }).toList(),
                    ), 
                ],
            ),
        );    
    }
}