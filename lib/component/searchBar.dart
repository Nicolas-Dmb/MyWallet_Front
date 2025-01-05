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
    bool isSelect = false;
    //token 
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? _accessToken;

    //return Value 
    Map<String, dynamic>? returnValue;

    //call API
    bool onLoad = true;
    String? _errorMessage; 
    String? _responseMessage; 
    bool search = false;

    //input  
    final TextEditingController _input = TextEditingController();

    // datas 
    late List<Map<String, dynamic>> assetsGeneral = [];
    List<Map<String, dynamic>> assetsUser = [];
   

    //print list
    List<Map<String, dynamic>> printListG = [];
    List<Map<String, dynamic>> printListU = [];
    List<Map<String, dynamic>> assetsGPT = [];
    Future<void> findList() async {
        printListU.clear();
        printListG.clear();
    
        printListU = assetsUser.where((assetU) {
            String ticker = assetU['ticker'].toLowerCase();
            String company = assetU['company'].toLowerCase();
            return ticker.contains(_input.text.toLowerCase()) || company.contains(_input.text.toLowerCase());
        }).toList();

        printListG = assetsGeneral.where((assetG) {
            String ticker = assetG['ticker'].toLowerCase();
            String company = assetG['company'].toLowerCase();
            return (ticker.contains(_input.text.toLowerCase()) || company.contains(_input.text.toLowerCase())) && 
                !printListU.any((asset) => asset['ticker'] == assetG['ticker']);
        }).toList();

        setState(() {}); // Rafraîchissement de l'état après la modification des listes
    }


    //detecte si on doit appeler findList ou attendre la find de la saisie : 
    Timer? _debounce;

    void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
        print("on appel findList");
        setState((){
            search=false;
            isSelect=false;
        });
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
                    print('ca passe dans bourse');
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
        print("on récupère les assets generaux");
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
            print("réponse d'assetG : ${response.statusCode}");
            if(response.statusCode == 200){
                final responseData = json.decode(response.body);
                setState(() {
                    assetsGeneral = List<Map<String, dynamic>>.from(responseData);
                });
                print("list d'assetGeneral : ${assetsGeneral}");
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
        print("on vient dans assetsU ${categorie}");
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
            print("réponse d'assetU : ${response.statusCode}");
            if(response.statusCode == 200){
                final responseData = json.decode(response.body);
                setState(() {
                    assetsUser.addAll(List<Map<String, dynamic>>.from(responseData));
                });
                print("list d'assetUser : ${ assetsUser}");
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

    //find ticker and send new assetG
    Future<void> searchTicker() async {
        print("passage dans searchTicker");
        setState((){
            onLoad = true;
            search = true;
        });
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/general/${_input.text}/");
        try{
            final response = await http.get(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
            );
            print("réponse de searchTicker : ${response.statusCode}");
            if(response.statusCode == 200){
                final responseData = json.decode(response.body);
                setState(() {
                    assetsGPT.addAll(List<Map<String, dynamic>>.from(responseData));
                });
                print("list assetsGPT : ${assetsGPT}");
            }else{
                final responseData = json.decode(response.body);
                setState((){
                    _errorMessage = "Error : ${responseData}";
                });
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la recherche de nouveaux assets.${e}";
            });
        }finally{
            setState((){
                onLoad=false;
            });
        }
    }

    Future<void> registerNewAssets(String ticker) async {
        print("passage dans registerNewAsset");
        onLoad = true;
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/asset/");
        try{
            final response = await http.post(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
                body:json.encode({'ticker':ticker}),
            );
            print("réponse de registerNewAssets: ${response.statusCode}");
            if(response.statusCode == 201){
                getAssetsG();
                final responseData = json.decode(response.body);
                print("creation de l'asset : ${responseData}");
                setState(() {
                    _input.text = "Entreprise : ${responseData['company']}  / Ticker: ${responseData['ticker']}  /  Prix: ${responseData['last_value']}";
                    returnValue = responseData;
                    widget.onClick(returnValue!);
                    printListU.clear();
                    printListG.clear();
                    isSelect=true;
                });
                
            }else{
                final responseData = json.decode(response.body);
                setState((){
                    _errorMessage = "Error : ${responseData}";
                });
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la création d'un nouvel asset.${e}";
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
        child:Column(
            children:[
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width < 550
                        ? MediaQuery.of(context).size.width 
                        : MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                        color: Color(int.parse(widget.colors['interactive1'])),
                        borderRadius: BorderRadius.circular(25),
                    ),
                    child: onLoad
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        children: [
                            if(isSelect==false)...[
                                SvgPicture.asset(
                                    'assets/search.svg',
                                    color: Color(int.parse(widget.colors['border2'])),
                                ),
                            ],
                            SizedBox(width: 10),
                            Expanded(
                                child: TextField(
                                    controller: _input,
                                    style: TextStyle(
                                        color: Color(int.parse(widget.colors['text2'])),
                                    ),
                                    decoration: InputDecoration(
                                        hintText: 'Rechercher...',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Color(int.parse(widget.colors['text2'])),
                                        ),
                                        contentPadding: EdgeInsets.only(bottom: 8),
                                    ),
                                    onChanged: onSearchChanged,
                                ),
                            ),
                        ],
                    ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width < 550
                        ? MediaQuery.of(context).size.width 
                        : MediaQuery.of(context).size.width * 0.3,
                    height: _input.text.length>0 && isSelect==false ? search==false ? ((printListG.length+printListU.length+assetsGPT.length)*60)+40 : ((printListG.length+printListU.length+assetsGPT.length)*60): MediaQuery.of(context).size.height * 0,
                    constraints:BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,  // Limite la hauteur maximale
                    ),
                    decoration: BoxDecoration(
                        color: Color(int.parse(widget.colors['interactive1'])),
                        borderRadius: BorderRadius.circular(25),
                    ),
                    child : Column(
                        children: [
                            // Liste des suggestions dans un seul ListView
                            Expanded(
                                child: ListView.builder(
                                    itemCount: printListU.length +
                                        printListG.length +
                                        assetsGPT.length +
                                        (_input.text.length > 0 && search == false ? 1 : 0),
                                    itemBuilder: (context, index) {
                                        if (index < printListU.length) {
                                            var item = printListU[index];
                                            return ListTile(
                                                title: Text(item['company'] ?? 'No company'),
                                                subtitle: Text(
                                                    "Ticker: ${item['ticker']}  /  Prix: ${item['actual_price']}",
                                                ),
                                                onTap: () {
                                                    _input.text =
                                                        "Entreprise : ${item['company']}  / Ticker: ${item['ticker']}  /  Prix: ${item['actual_price']}";
                                                    returnValue = item;
                                                    widget.onClick(returnValue!);
                                                    printListU.clear();
                                                    printListG.clear();
                                                    isSelect=true;
                                                },
                                            );
                                        } else if (index < printListU.length + printListG.length && isSelect==false) {
                                            var item = printListG[index - printListU.length];
                                            return ListTile(
                                                title: Text(item['company'] ?? 'No company'),
                                                subtitle: Text(
                                                    "Ticker: ${item['ticker']}  /  Prix: ${item['last_value']}",
                                                ),
                                                onTap: () {
                                                    _input.text =
                                                        "Entreprise : ${item['company']}  / Ticker: ${item['ticker']}  /  Prix: ${item['last_value']}";
                                                    returnValue = item;
                                                    widget.onClick(returnValue!);
                                                    printListU.clear();
                                                    printListG.clear();
                                                    isSelect=true;
                                                },
                                            );
                                        } else if (index < printListU.length + printListG.length + assetsGPT.length && isSelect==false) {
                                            var item = assetsGPT[index - printListU.length - printListG.length];
                                            return ListTile(
                                                title: Text(item['company'] ?? 'Not find'),
                                                subtitle: Text(
                                                    "Type: ${item['type'] ?? 'Not find'}  /  Ticker: ${item['ticker']}  /  Pays: ${item['country'] ?? 'Not find'}",
                                                ),
                                                onTap: () {
                                                    if (item.containsKey('error')) {
                                                        _input.text = "Ticker: ${item['ticker']}";
                                                        returnValue = item;

                                                        if (returnValue != null) {
                                                            widget.onClick(returnValue!);
                                                        }

                                                        printListU.clear();
                                                        printListG.clear();
                                                        isSelect=true;
                                                    } else {
                                                        registerNewAssets(item['ticker']);
                                                    }
                                                },
                                            );
                                        } else if (_input.text.length > 0 && search == false && isSelect==false ) {
                                            return ElevatedButton(
                                                onPressed: () => searchTicker(),
                                                child: const Text('Rechercher de nouveaux actifs'),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(int.parse(widget.colors['interactive3'])),
                                                    foregroundColor: Color(int.parse(widget.colors['text1'])),
                                                    overlayColor: Color(int.parse(widget.colors['interactive1'])),
                                                    textStyle: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                            );
                                        }
                                        return SizedBox(); 
                                    },
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
    /*@override
Widget build(BuildContext context) {
    return Container(
        children:[
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width < 550
                    ? MediaQuery.of(context).size.width * 0.7
                    : MediaQuery.of(context).size.width * 0.3,
                height: _input.text.length>0 && isSelect==false ? search==false ? ((printListG.length+printListU.length+assetsGPT.length)*60)+40+MediaQuery.of(context).size.height * 0.06 : ((printListG.length+printListU.length+assetsGPT.length)*60)+MediaQuery.of(context).size.height * 0.06: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    color: Color(int.parse(widget.colors['interactive1'])),
                    borderRadius: BorderRadius.circular(25),
                ),
                constraints:BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,  // Limite la hauteur maximale
                ),
            ),
            Container(
            child: onLoad
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                        Row(
                            children: [
                                if(isSelect==false)...[
                                    SvgPicture.asset(
                                        'assets/search.svg',
                                        color: Color(int.parse(widget.colors['border2'])),
                                    ),
                                ],
                                SizedBox(width: 10),
                                Expanded(
                                    child: TextField(
                                        controller: _input,
                                        style: TextStyle(
                                            color: Color(int.parse(widget.colors['text2'])),
                                        ),
                                        decoration: InputDecoration(
                                            hintText: 'Rechercher...',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Color(int.parse(widget.colors['text2'])),
                                            ),
                                            contentPadding: EdgeInsets.only(bottom: 8),
                                        ),
                                        onChanged: onSearchChanged,
                                    ),
                                ),
                            ],
                        ),
                        // Liste des suggestions dans un seul ListView
                        Expanded(
                            child: ListView.builder(
                                itemCount: printListU.length +
                                    printListG.length +
                                    assetsGPT.length +
                                    (_input.text.length > 0 && search == false ? 1 : 0),
                                itemBuilder: (context, index) {
                                    if (index < printListU.length) {
                                        var item = printListU[index];
                                        return ListTile(
                                            title: Text(item['company'] ?? 'No company'),
                                            subtitle: Text(
                                                "Ticker: ${item['ticker']}  /  Prix: ${item['actual_price']}",
                                            ),
                                            onTap: () {
                                                _input.text =
                                                    "Entreprise : ${item['company']}  / Ticker: ${item['ticker']}  /  Prix: ${item['actual_price']}";
                                                returnValue = item;
                                                widget.onClick(returnValue!);
                                                printListU.clear();
                                                printListG.clear();
                                                isSelect=true;
                                            },
                                        );
                                    } else if (index < printListU.length + printListG.length && isSelect==false) {
                                        var item = printListG[index - printListU.length];
                                        return ListTile(
                                            title: Text(item['company'] ?? 'No company'),
                                            subtitle: Text(
                                                "Ticker: ${item['ticker']}  /  Prix: ${item['last_value']}",
                                            ),
                                            onTap: () {
                                                _input.text =
                                                    "Entreprise : ${item['company']}  / Ticker: ${item['ticker']}  /  Prix: ${item['last_value']}";
                                                returnValue = item;
                                                widget.onClick(returnValue!);
                                                printListU.clear();
                                                printListG.clear();
                                                isSelect=true;
                                            },
                                        );
                                    } else if (index < printListU.length + printListG.length + assetsGPT.length && isSelect==false) {
                                        var item = assetsGPT[index - printListU.length - printListG.length];
                                        return ListTile(
                                            title: Text(item['company'] ?? 'Not find'),
                                            subtitle: Text(
                                                "Type: ${item['type'] ?? 'Not find'}  /  Ticker: ${item['ticker']}  /  Pays: ${item['country'] ?? 'Not find'}",
                                            ),
                                            onTap: () {
                                                if (item.containsKey('error')) {
                                                    _input.text = "Ticker: ${item['ticker']}";
                                                    returnValue = item;

                                                    if (returnValue != null) {
                                                        widget.onClick(returnValue!);
                                                    }

                                                    printListU.clear();
                                                    printListG.clear();
                                                    isSelect=true;
                                                } else {
                                                    registerNewAssets(item['ticker']);
                                                }
                                            },
                                        );
                                    } else if (_input.text.length > 0 && search == false && isSelect==false ) {
                                        return ElevatedButton(
                                            onPressed: () => searchTicker(),
                                            child: const Text('Rechercher de nouveaux actifs'),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(int.parse(widget.colors['interactive3'])),
                                                foregroundColor: Color(int.parse(widget.colors['text1'])),
                                                overlayColor: Color(int.parse(widget.colors['interactive1'])),
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                        );
                                    }
                                    return SizedBox(); 
                                },
                            ),
                        ),
                        if (onLoad) const Center(child: CircularProgressIndicator()),
                    ],
                ),
            ),
        ],
    );
}
}
*/