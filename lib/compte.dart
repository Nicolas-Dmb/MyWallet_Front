import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'component/tokenManager.dart';
import 'component/header.dart';
import 'component/lineChart.dart';
import 'component/textButton.dart';

class Compte extends StatefulWidget{
    const Compte({Key? key}):super(key:key);

    @override
    State<Compte> createState() => _CompteState();
}

class _CompteState extends State<Compte>{
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? _accessToken;
    final _formKey = GlobalKey<FormState>();
    bool _modif = false;
    String? _errorMessage; 

    //compte
    final TextEditingController _username = TextEditingController();
    final TextEditingController _nom = TextEditingController();
    final TextEditingController _prenom = TextEditingController();
    final TextEditingController _email = TextEditingController();
    final TextEditingController _tel = TextEditingController();
    final TextEditingController _pays = TextEditingController();
    final TextEditingController _profession = TextEditingController();
    final TextEditingController _revenus = TextEditingController();
    DateTime? _dateBirth;
    //Setting 
    final TextEditingController _device = TextEditingController();
    final TextEditingController _nightMode =  TextEditingController();
    final TextEditingController _color = TextEditingController();

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

    @override
    void dispose() {
        _username.dispose();
        _nom.dispose();
        _prenom.dispose();
        _email.dispose();
        _tel.dispose();
        _pays.dispose();
        _profession.dispose();
        _revenus.dispose();
        super.dispose();
        _device.dispose();
        _nightMode.dispose();
        _color.dispose();
    }

    //Call Setting data
    Future<void> _getSetting() async{
        checkAccessToken(context);
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
                final responseData = json.decode(response.body);
                setState((){
                    _username.text = responseData['username'];
                    _nom.text = responseData['lastName'];
                    _prenom.text = responseData['firstName'];
                    _email.text = responseData['email'];
                    _tel.text = responseData['phone'];
                    _pays.text = responseData['country'];
                    _profession.text = responseData['job'];
                    _revenus.text = responseData['income'];
                    _dateBirth = DateTime.tryParse(responseData['birthday'] ?? '');
                });
            }else{
                setState((){
                    _errorMessage = "Error : ${response.statusCode}";
                });
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la récupération des données.${e}";
            });
        }
    }

    //Call Account data 
    Future<void> _setSetting() async{
        checkAccessToken(context);
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/user/");
        try{
            final response = await http.post(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
                body:json.encode({
                    'username': _username.text,
                    'lastName' : _nom.text,
                    'firstName' : _prenom.text,
                    'email' : _email.text,
                    'phone' : _tel.text,
                    'country' : _pays.text,
                    'job' : _profession.text,
                    'income' : _revenus.text,
                    'birthday' : _dateBirth?.toIso8601String(),
                }),
            );
            if (response.statusCode==200){
                final responseData = json.decode(response.body);
                setState(() {
                    _modif = false;
                });
            }else{
                setState((){
                    _errorMessage = "Error : ${response.statusCode}";
                });
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la mise à jour des données.${e}";
            });
        }
    }
    //Call OTP modif account
    @override
    Widget build(BuildContext contex){
        return Container(
            color: const Color(0xFF181111),
            height : double.infinity,
            padding : EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 700 ?  MediaQuery.of(context).size.width*0.1 : 0,
                vertical:MediaQuery.of(context).size.height*0.05,
            ),
            child: Column(
                Header(isConnect: true),
                children:[
                    Image.asset('assets/informations.png', width : MediaQuery.of(context).size.width*0.5),
                    ElevatedButton(
                        onPressed: () {
                            setState(() {
                                _modif = !_modif;
                            });
                        },
                        child: const Text('Modifier'),
                        style :ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEC6142), 
                            foregroundColor: const Color(0xFFFF977D),
                            overlayColor: const Color(0xFF391714), 
                            textStyle: const TextStyle( 
                            fontWeight: FontWeight.bold,
                            ),
                        ),
                    ),
                    Form(
                        key : _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                TextFormField(
                                    readOnly : _modif,
                                    controller : _username,
                                    style : TextStyle(color: Color(0xFFFBD3CB)),
                                    decoration : const InputDecoration(labelText: 'Identifiant'),
                                    validator : (value){
                                        if (value == null || value.isEmpty){
                                        return 'Veuillez entrer votre Identifiant';
                                        }
                                        return null;
                                    },
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                    children:[
                                        TextFormField(
                                            readOnly : _modif,
                                            controller : _nom,
                                            style : TextStyle(color: Color(0xFFFBD3CB)),
                                            decoration : const InputDecoration(labelText: 'Nom'),
                                            validator : (value){
                                                if (value == null || value.isEmpty){
                                                return 'Veuillez entrer votre Identifiant';
                                                }
                                                return null;
                                            },
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.width*0.1),
                                        TextFormField(
                                            readOnly : _modif,
                                            controller : _prenom,
                                            style : TextStyle(color: Color(0xFFFBD3CB)),
                                            decoration : const InputDecoration(labelText: 'Prénom'),
                                            validator : (value){
                                                if (value == null || value.isEmpty){
                                                return 'Veuillez entrer votre Identifiant';
                                                }
                                                return null;
                                            },
                                        ),
                                    ]
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width*0.1),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                    children:[
                                        TextFormField(
                                            readOnly : _modif,
                                            controller : _email,
                                            style : TextStyle(color: Color(0xFFFBD3CB)),
                                            decoration : const InputDecoration(labelText: 'Email'),
                                            validator : (value){
                                                if (value == null || value.isEmpty) {
                                                    return 'Veuillez entrer votre Email';
                                                }else if(!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
                                                    return 'Veuillez retourner un Email valide';
                                                }
                                                return null;
                                            },
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.width*0.1),
                                        TextFormField(
                                            readOnly : _modif,
                                            controller : _tel,
                                            style : TextStyle(color: Color(0xFFFBD3CB)),
                                            decoration : const InputDecoration(labelText: 'Téléphone'),
                                            validator : (value){
                                                if (value == null || value.isEmpty){
                                                return 'Veuillez entrer votre Identifiant';
                                                }
                                                return null;
                                            },
                                        ),
                                    ],
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width*0.1),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                    children:[
                                        TextFormField(
                                            readOnly : _modif,
                                            controller : _pays,
                                            style : TextStyle(color: Color(0xFFFBD3CB)),
                                            decoration : const InputDecoration(labelText: 'Pays'),
                                            validator : (value){
                                                if (value == null || value.isEmpty){
                                                return 'Veuillez entrer votre Identifiant';
                                                }
                                                return null;
                                            },
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.width*0.1),
                                        TextFormField(
                                            readOnly : _modif,
                                            controller : _profession,
                                            style : TextStyle(color: Color(0xFFFBD3CB)),
                                            decoration : const InputDecoration(labelText: 'Profession'),
                                            validator : (value){
                                                if (value == null || value.isEmpty){
                                                return 'Veuillez entrer votre Identifiant';
                                                }
                                                return null;
                                            },
                                        ),
                                    ],
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width*0.1),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                    children:[
                                        TextFormField(
                                            readOnly : _modif,
                                            controller : _revenus,
                                            style : TextStyle(color: Color(0xFFFBD3CB)),
                                            decoration : const InputDecoration(labelText: 'Revenus'),
                                            validator : (value){
                                                if (value == null || value.isEmpty){
                                                return 'Veuillez entrer votre Identifiant';
                                                }
                                                return null;
                                            },
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.width*0.1),
                                        ElevatedButton(
                                            onPressed: () async {
                                                final selectedDate = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1930),
                                                    lastDate: DateTime(2030),
                                                );
                                                if (selectedDate != null) {
                                                    setState(() {
                                                    _dateBirth = selectedDate;
                                                    });
                                                }
                                            },
                                            child: Text('Select Date'),
                                        ),
                                    ],
                                ),
                                if( _modif)
                                    ElevatedButton(
                                        onPressed:()=> _setSetting(),
                                        child: const Text('Envoyer'),
                                        style :ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFEC6142), 
                                            foregroundColor: const Color(0xFFFF977D),
                                            overlayColor: const Color(0xFF391714), 
                                            textStyle: const TextStyle( 
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                    ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}

/*
*/