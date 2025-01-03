import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'tokenManager.dart';
import 'getSetting.dart';
import './svgButton.dart';
import './textButton.dart';

class SearchBar extends StatefulWidget {
    final Map<String, dynamic> colors; 
    final String categorie;//permet de séléctionner les assets que l'on veut
    final  Function(Map<String, dynamic>) onClick; 

    const SearchBar({
        required this.colors,
        this.categorie = 'all',
        required this.onClick,
        super.key,
    });

    @override
    State<SearchBar> createState() => _SearchBarState();

}

class _SearchBarState extends State<SearchBar>{
    //token 
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? _accessToken;

    //return Value 
    Map<String, dynamic>? returnValue;

    //call API
    bool onLoad = true;
    String? _errorMessage; 
    String? _responseMessage; 

    //input  
    final TextEditingController _input = TextEditingController();

    // datas 
    late List<Map<String, dynamic>> assetsGeneral = [];
    List<Map<String, dynamic>> assetsUser = [];

    //print list
    List<Map<String, dynamic>> printListG = [];
    List<Map<String, dynamic>> printListU = [];
    Future<void> findList() async {
    printListU.clear();
    printListG.clear();
   
    printListU = assetsUser.where((assetU) {
        return assetU['ticker'].contains(_input.text) || assetU['company'].contains(_input.text);
    }).toList();

    printListG = assetsGeneral.where((assetG) {
        return (assetG['ticker'].contains(_input.text) || assetG['company'].contains(_input.text)) && 
            !printListU.any((asset) => asset['ticker'] == assetG['ticker']);
    }).toList();

    setState(() {}); // Rafraîchissement de l'état après la modification des listes
    }


    //detecte si on doit appeler findList ou attendre la find de la saisie : 
    Timer? _debounce;

    void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
        findList();
    });
    }

    @override
    void initState() {
        super.initState();
        checkAccessToken(context).then((_) {
            if (_accessToken != null) {
                getAssetsG();
                if(widget.categorie=='all'){
                    getAssetsU('crypto');
                    getAssetsU('bourse');
                    getAssetsU('cash');
                    getAssetsU('immo');
                }else if(widget.categorie=='bourse'){
                     getAssetsU('bourse');
                }else if(widget.categorie=='crypto'){
                     getAssetsU('crypto');
                }else if(widget.categorie=='immo'){
                     getAssetsU('immo');
                }else if(widget.categorie=='cash'){
                     getAssetsU('cash');
                }
            }
        });
    }

    @override 
    void dispose(){
        _input.dispose();
        super.dispose();
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
    //Get assetGeneral
    Future<void> getAssetsG() async {
        onLoad = true;
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/asset/");
        try{
            final response = await http.get(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
            );
            if(response.statusCode == 200){
                final responseData = json.decode(response.body);
                setState(() {
                    assetsGeneral = List<Map<String, dynamic>>.from(responseData);
                });
            }else{
                final responseData = json.decode(response.body);
                setState((){
                    _errorMessage = "Error : ${responseData}";
                });
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la récupération des assets généraux.${e}";
            });
        }finally{
            setState((){
                onLoad=false;
            });
        }
    }

    //getAssetUser
    Future<void> getAssetsU(String categorie) async {
        onLoad = true;
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/wallet/list/$categorie/");
        try{
            final response = await http.get(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
            );
            if(response.statusCode == 200){
                final responseData = json.decode(response.body);
                setState(() {
                    assetsUser.addAll(List<Map<String, dynamic>>.from(responseData));
                });
            }else{
                final responseData = json.decode(response.body);
                setState((){
                    _errorMessage = "Error : ${responseData}";
                });
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la récupération des assets users.${e}";
            });
        }finally{
            setState((){
                onLoad=false;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width:  MediaQuery.of(context).size.width < 550 ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
                color: Color(int.parse(widget.colors['interactive1'])),
                borderRadius: BorderRadius.circular(25),
            ),
            child: onLoad
            ? Center(child: CircularProgressIndicator())
            : Row(
                children: [
                    SvgPicture.asset('assets/search.svg',color: Color(int.parse(widget.colors['border2']))),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            controller: _input,
                            style: TextStyle(
                                color : Color(int.parse(widget.colors['text2'])), 
                            ),
                            decoration: InputDecoration(
                                hintText: 'Rechercher...',
                                border: InputBorder.none,
                                hintStyle: TextStyle( // Style pour le placeholder
                                color: Color(int.parse(widget.colors['text2'])), 
                                ),
                                contentPadding: EdgeInsets.only(bottom: 8),
                            ),
                            onChanged: onSearchChanged,
                        ),
                    ),
                    // Afficher la liste des assetsUser filtrés
                if (printListU.isNotEmpty) 
                    Expanded(
                    child: ListView.builder(
                        itemCount: printListU.length,
                        itemBuilder: (context, index) {
                        var item = printListU[index];
                        return ListTile(
                            title: Text(item['company'] ?? 'No company'), // Remplacez par le champ pertinent de votre map
                            subtitle: Text("Ticker: ${item['ticker']}  /  Prix: ${item['actual_price']}" ),
                            onTap: () {
                                _input.text = "Entreprise : ${item['company']}  / Ticker: ${item['ticker']}  /  Prix: ${item['actual_price']}";
                                returnValue = item;
                                widget.onClick(returnValue!);
                                printListU.clear();
                                printListG.clear();
                            },
                        );
                        },
                    ),
                    ),
                // Afficher la liste des assetsGeneral filtrés
                if (printListG.isNotEmpty)
                    Expanded(
                    child: ListView.builder(
                        itemCount: printListG.length,
                        itemBuilder: (context, index) {
                        var item = printListG[index];
                        return ListTile(
                            title: Text(item['company'] ?? 'No company'), // Remplacez par le champ pertinent de votre map
                            subtitle: Text("Ticker: ${item['ticker']}  /  Prix: ${item['last_value']}" ),
                            onTap: () {
                                 _input.text = "Entreprise : ${item['company']}  / Ticker: ${item['ticker']}  /  Prix: ${item['actual_price']}";
                                returnValue = item;
                                widget.onClick(returnValue!);
                                printListU.clear();
                                printListG.clear();
                            },
                        );
                        },
                    ),
                    ),
                ],
            ),
        );
    }
}

