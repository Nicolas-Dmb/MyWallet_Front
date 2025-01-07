import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'tokenManager.dart';
import 'getSetting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'searchBar.dart' as SearchBar; 

class BourseForm extends StatefulWidget{
    late bool isSell; 
    BourseForm({
        required this.isSell,
        super.key,
        });

    @override
    State<BourseForm> createState() => _BourseFormState();
}

class _BourseFormState extends State<BourseForm>{
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? _accessToken;
    final _formKey = GlobalKey<FormState>();
    String? _errorMessage;
    String? _responseMessage;
    bool isReady = false;
    final List<String> listAssets = <String>['','BTC','ETH','Stablecoins','Altcoins','NFT'];
    List<String> industry = <String>['','Technologie', 'Santé', 'Finance', 'Énergie', 'Matériaux de base', 'Industrie', 'Consommation cyclique', 'Consommation non cyclique','Télécommunications', 'Immobilier','Services publics','Commodities', 'Gold'];
    List<String> country = <String>['','Europe','Amérique du Nord','Amérique du sud','Afrique','Asie','Moyen-Orient','Océanie'];
    final List<String> listAccountStock = <String>['','PEA','CTO','Ass_Vie','CSL_LEP','autre'];
    late List<Map<String, dynamic>> listAccountdebit;
    bool onLoad = true;
    late Map<String, dynamic> colors; 
    late String? _currency;

    //input
    final TextEditingController _name = TextEditingController();
    final TextEditingController _ticker = TextEditingController();
    final TextEditingController _categorie = TextEditingController();
    final TextEditingController _localisation = TextEditingController();
    final TextEditingController _activite = TextEditingController();
    final TextEditingController _nombre = TextEditingController();
    final TextEditingController _prixUnit = TextEditingController();
    final TextEditingController _plateforme = TextEditingController();
    final TextEditingController _typeCompte = TextEditingController();
    final TextEditingController _compteDebiteAccount = TextEditingController();
    final TextEditingController _compteDebiteBank = TextEditingController();
    DateTime? _date;

    @override
    void initState() {
        super.initState();
        _categorie.text = 'Action';
        _localisation.text = '';
        _activite.text = '';
        _typeCompte.text ='';
        _date = DateTime.now();
        checkAccessToken(context).then((_) {
            if (_accessToken != null) {
                getCashAccount();
            }
        });
        initializeSettings();
    }
    Future<void> initializeSettings() async {
        // Initialiser SharedPreferences via votre classex
        final prefs = await SharedPreferences.getInstance();
        setState((){
            colors = jsonDecode(prefs.getString('colors').toString()??'');
            _currency = prefs.getString('devise').toString()??'';
            isReady = true;
        });
        print('isReady : ${isReady}');
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

    @override
    void dispose() {
        _ticker.dispose();
        _name.dispose();
        _categorie.dispose();
        _localisation.dispose();
        _activite.dispose();
        _nombre.dispose();
        _prixUnit.dispose();
        _plateforme.dispose();
        _typeCompte.dispose();
        _compteDebiteAccount.dispose();
        _compteDebiteBank.dispose();
        super.dispose();
    }

    //Get Cash account
    Future<void> getCashAccount() async{
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/cash/");
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
                    listAccountdebit = List<Map<String, dynamic>>.from(responseData);
                });
            }else{
                final responseData = json.decode(response.body);
                setState((){
                    _errorMessage = "Error : ${responseData}";
                });
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la récupération des comptes.${e}";
            });
        }finally{
            setState((){
                onLoad=false;
            });
        }
    }

    Future<void> sendData() async{
        final formattedDate = _date != null
            ? "${_date!.year.toString().padLeft(4, '0')}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}"
            : '';

        final Map<String, dynamic> body = {
            //pour créer le buy :
            if( _currency=="Euro")"currency":'EUR',
            if( _currency!="Euro")"currency":'USD',
            "name": _name.text,
            "plateforme": _plateforme.text,
            if (_typeCompte.text != '') "account": _typeCompte.text,
            //number_sold : 
            if(widget.isSell)"number_sold":_nombre.text,
            if(widget.isSell)"price_sold":_prixUnit.text,
            if(widget.isSell)"date_sold":formattedDate,
            if(!widget.isSell)"number_buy": _nombre.text,
            if(!widget.isSell)"price_buy": _prixUnit.text,
            if(!widget.isSell)"date_buy": formattedDate,
            "ticker": _ticker.text,
            //Bourse detail : 
            "bourseDetail":{
                "sous_category": _categorie.text,
                if (_activite.text != '') "industry": _activite.text,
            },
            //Si API ne connait pas : 
            "type": 'Bourse',
            "categories": 'Default',//categories est affecté à category via une self.action de assets.create_asset_withoutAPI
            "country": _localisation.text,
            "sector": 'Default',
            "company": 'Default',
            //dans tous les cas : 
            if(_compteDebiteAccount.text != '' && _compteDebiteBank.text != '')
            "cashDetail":{
                "account": _compteDebiteAccount.text,
                "bank": _compteDebiteBank.text,
            },
        };
        checkAccessToken(context);
        final url = widget.isSell ? Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/wallet/sell/") : Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/wallet/buy/");
        try{
            final response = await http.post(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
                body:json.encode(body),
            );
            if(response.statusCode == 201){
                setState((){
                    _responseMessage = "L'achat a bien été enregistré.";
                });
            }else{
                final responseData = json.decode(response.body);
                setState((){
                    _errorMessage = "Error : ${responseData}";
                });
                print("ResponseData de send buy : ${responseData}");
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la récupération des comptes.${e}";
            });
        }finally{
            setState((){
                onLoad=false;
            });
        }
    }
    Widget build(BuildContext context){
        return !isReady || onLoad ? 
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
        SingleChildScrollView(
            child : Stack(
                children:[
                    //barre de recherche
                    SizedBox(height:MediaQuery.of(context).size.height*0.1),
                    Column(
                        children:[
                            //Réglagle pour ordi
                            SizedBox(height:MediaQuery.of(context).size.height*0.2),
                            if (MediaQuery.of(context).size.width > 900)... [
                                    Row(
                                        mainAxisAlignment : MainAxisAlignment.center,
                                        children:[
                                            //SizedBox(height:MediaQuery.of(context).size.height*0.15),
                                            SizedBox(
                                                width:MediaQuery.of(context).size.width/4,
                                                child:TextFormField( 
                                                    decoration: InputDecoration(labelText: "Ticker",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                    controller :_ticker,
                                                    style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                    validator : (value){
                                                        if (value == null || value.isEmpty){
                                                            return 'Veuillez entrer un ticker';
                                                        }
                                                        return null;
                                                    },
                                                ),
                                            ),
                                            SizedBox(width:MediaQuery.of(context).size.width*0.1),
                                            SizedBox(
                                                width:MediaQuery.of(context).size.width/4,
                                                child:TextFormField( 
                                                    decoration: InputDecoration(labelText: "Nom de l'actif",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                    controller :_name,
                                                    style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                    validator : (value){
                                                        if (value == null || value.isEmpty){
                                                            return 'Veuillez entrer un Nom';
                                                        }
                                                        return null;
                                                    },
                                                ),
                                            ),
                                        ], 
                                    ),
                                    SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                    Row(
                                        mainAxisAlignment : MainAxisAlignment.center,
                                        children:[
                                            Text("Catégorie",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                            SizedBox(width:MediaQuery.of(context).size.width*0.05),
                                            DropdownButton<String>(
                                                value: _categorie.text,
                                                icon: const Icon(Icons.arrow_downward),
                                                elevation: 12,
                                                style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                        _categorie.text = value??'';
                                                    });
                                                },
                                                items: listAssets.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                    );
                                                }).toList(),
                                            ), 
                                            SizedBox(width:MediaQuery.of(context).size.width*0.1),
                                            if(!widget.isSell)...[
                                                Text("Secteur Géographique",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                SizedBox(width:MediaQuery.of(context).size.width*0.05),
                                                DropdownButton<String>(
                                                    value:  _localisation.text.isEmpty
                                                            ? country[0]
                                                            : _localisation.text,
                                                    icon: const Icon(Icons.arrow_downward),
                                                    elevation: 12,
                                                    style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                    onChanged: (String? value) {
                                                        // This is called when the user selects an item.
                                                        setState(() {
                                                            _localisation.text = value ?? country[0]; 
                                                        });
                                                    },
                                                    items: country.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                        );
                                                    }).toList(),
                                                ),
                                                SizedBox(width:MediaQuery.of(context).size.width*0.1),
                                            
                                                Text("Activité",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                SizedBox(width:MediaQuery.of(context).size.width*0.05),
                                                DropdownButton<String>(
                                                    value:  _activite.text.isEmpty
                                                            ? industry[0]
                                                            :  _activite.text,
                                                    icon: const Icon(Icons.arrow_downward),
                                                    elevation: 12,
                                                    style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                    onChanged: (String? value) {
                                                        // This is called when the user selects an item.
                                                        setState(() {
                                                            _activite.text = value ?? '';
                                                        });
                                                    },
                                                    items: industry.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                        );
                                                    }).toList(),
                                                ), 
                                            ],
                                        ],
                                    ),
                                    SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                    Row(
                                        mainAxisAlignment : MainAxisAlignment.center,
                                        children:[
                                            widget.isSell ? Text("Date de vente",style: TextStyle(color: Color(int.parse(colors['text1'])))) : Text("Date d'achat",style: TextStyle(color: Color(int.parse(colors['text1'])))) ,
                                            SizedBox(width:MediaQuery.of(context).size.width*0.05),
                                            ElevatedButton(
                                                onPressed: () async {
                                                    final selectedDate = await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime(1960),
                                                        lastDate: DateTime.now(),
                                                    );
                                                    if (selectedDate != null) {
                                                        setState(() {
                                                        _date = selectedDate;
                                                        });
                                                    }
                                                },
                                                child: Text(_date == null ? 'Select date':"${_date!.year.toString().padLeft(4, '0')}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}"),
                                            ),
                                            SizedBox(width:MediaQuery.of(context).size.width*0.1),
                                            SizedBox(
                                                width:MediaQuery.of(context).size.width/4,
                                                child:TextFormField( 
                                                    decoration: InputDecoration(labelText:widget.isSell ?"Nombre vendu" :"Nombre acheté",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                    controller : _nombre,
                                                    style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                    keyboardType: TextInputType.number, 
                                                    inputFormatters: <TextInputFormatter>[ 
                                                        FilteringTextInputFormatter.digitsOnly,
                                                    ], // Only numbers can be entered 
                                                    validator : (value){
                                                        if (value == null || value.isEmpty||value=='0'){
                                                            return 'Veuillez entrer un nombre supérieur à 0';
                                                        }
                                                        return null;
                                                    },
                                                ),
                                            ),
                                            SizedBox(width:MediaQuery.of(context).size.width*0.1),
                                            SizedBox(
                                                width:MediaQuery.of(context).size.width/4,
                                                child:TextFormField( 
                                                    decoration: InputDecoration(labelText: "Prix Unitaire",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                    controller :_prixUnit,
                                                    style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                    keyboardType: TextInputType.number, 
                                                    inputFormatters: <TextInputFormatter>[ 
                                                        FilteringTextInputFormatter.digitsOnly 
                                                    ], // Only numbers can be entered 
                                                    validator : (value){
                                                        if (value == null || value.isEmpty||value=='0'){
                                                            return 'Veuillez entrer un nombre supérieur à 0';
                                                        }
                                                        return null;
                                                    },
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                    Row(
                                        mainAxisAlignment : MainAxisAlignment.center,
                                        children:[  
                                            Text("Compte",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                            SizedBox(width:MediaQuery.of(context).size.width*0.05),
                                            DropdownButton<String>(
                                                value: _typeCompte.text.isEmpty
                                                        ? listAccountStock[0]
                                                        :   _typeCompte.text,
                                                icon: const Icon(Icons.arrow_downward),
                                                elevation: 16,
                                                style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                onChanged: (String? value) {
                                                    setState(() {
                                                        _typeCompte.text = value ??'';
                                                    });
                                                },
                                                items: listAccountStock.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                    );
                                                }).toList(),
                                            ), 
                                            SizedBox(width:MediaQuery.of(context).size.width*0.1),
                                            SizedBox(
                                                width:MediaQuery.of(context).size.width/4,
                                                child:TextFormField( 
                                                    decoration: InputDecoration(labelText: "Plateforme",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                    controller :_plateforme,
                                                    style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                ),
                                            ),
                                            SizedBox(width:MediaQuery.of(context).size.width*0.1),
                                            if (listAccountdebit.length>0)...[
                                                Text("Compte à débiter",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                SizedBox(width:MediaQuery.of(context).size.width*0.05),
                                                DropdownButton<Map<String, dynamic>>(
                                                    value: _compteDebiteAccount.text.isEmpty
                                                        ? {}
                                                        : listAccountdebit?.firstWhere(
                                                            (account) =>
                                                                '${account['bank']} / ${account['account']}' == _compteDebiteAccount.text,
                                                            orElse: () => {},
                                                            ),
                                                    icon: const Icon(Icons.arrow_downward),
                                                    elevation: 16,
                                                    style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                    onChanged: (Map<String, dynamic>? value) {
                                                        setState(() {
                                                            if (value != null) {
                                                                _compteDebiteAccount.text = value['account']?.toString() ?? '';
                                                                _compteDebiteBank.text = value['bank']?.toString() ?? '';
                                                            }
                                                        });
                                                    },
                                                    items: listAccountdebit.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> account) {
                                                        return DropdownMenuItem<Map<String, dynamic>>(
                                                            value: account,
                                                            child: Text(
                                                            '${account['bank']} / ${account['account']}',
                                                            style: TextStyle(color: Color(int.parse(colors['text1']))),
                                                            ),
                                                        );
                                                    }).toList(),
                                                ), 
                                            ],
                                        ],
                                    ),
                            //Réglage pour phone et tablette
                            ]else ...[
                                Center(
                                    child:Column(
                                    children:[
                                        SizedBox(
                                            width:MediaQuery.of(context).size.width*0.7,
                                            child:TextFormField( 
                                                decoration: InputDecoration(labelText: "Ticker",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                controller :_ticker,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                validator : (value){
                                                    if (value == null || value.isEmpty){
                                                        return 'Veuillez entrer un ticker';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                        SizedBox(
                                            width:MediaQuery.of(context).size.width*0.7,
                                            child:TextFormField( 
                                                decoration: InputDecoration(labelText: "Nom de l'actif",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                controller :_name,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                validator : (value){
                                                    if (value == null || value.isEmpty){
                                                        return 'Veuillez entrer un Nom';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                        Text("Catégorie",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.01),
                                        Container(
                                            width:MediaQuery.of(context).size.width*0.7,
                                            child:DropdownButton<String>(
                                                isExpanded: true,
                                                value: _categorie.text,
                                                icon: const Icon(Icons.arrow_downward),
                                                elevation: 12,
                                                style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                onChanged: (String? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                        _categorie.text = value??'';
                                                    });
                                                },
                                                items: listAssets.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                    );
                                                }).toList(),
                                            ), 
                                        ),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                        if(!widget.isSell)...[
                                            Text("Secteur Géographique",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                            SizedBox(height:MediaQuery.of(context).size.height*0.01),
                                            Container(
                                                width:MediaQuery.of(context).size.width*0.7,
                                                child:DropdownButton<String>(
                                                    isExpanded: true,
                                                    value:  _localisation.text.isEmpty
                                                            ? country[0]
                                                            : _localisation.text,
                                                    icon: const Icon(Icons.arrow_downward),
                                                    elevation: 12,
                                                    style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                    onChanged: (String? value) {
                                                        // This is called when the user selects an item.
                                                        setState(() {
                                                            _localisation.text = value ?? country[0]; 
                                                        });
                                                    },
                                                    items: country.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                        );
                                                    }).toList(),
                                                ),
                                            ),
                                            SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                            Text("Activité",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                            SizedBox(height:MediaQuery.of(context).size.height*0.01),
                                            Container(
                                                width:MediaQuery.of(context).size.width*0.7,
                                                child:DropdownButton<String>(
                                                    isExpanded: true,
                                                    value:  _activite.text.isEmpty
                                                            ? industry[0]
                                                            :  _activite.text,
                                                    icon: const Icon(Icons.arrow_downward),
                                                    elevation: 12,
                                                    style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                    onChanged: (String? value) {
                                                        // This is called when the user selects an item.
                                                        setState(() {
                                                            _activite.text = value ?? '';
                                                        });
                                                    },
                                                    items: industry.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                        );
                                                    }).toList(),
                                                ), 
                                            ),
                                            SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                        ],
                                        widget.isSell ? Text("Date de vente",style: TextStyle(color: Color(int.parse(colors['text1'])))):Text("Date d'achat",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.02),
                                        ElevatedButton(
                                            onPressed: () async {
                                                final selectedDate = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1960),
                                                    lastDate: DateTime.now(),
                                                );
                                                if (selectedDate != null) {
                                                    setState(() {
                                                    _date = selectedDate;
                                                    });
                                                }
                                            },
                                            child: Text(_date == null ? 'Select date':"${_date!.year.toString().padLeft(4, '0')}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}"),
                                        ),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.05),
                                        SizedBox(
                                            width:MediaQuery.of(context).size.width*0.7,
                                            child:TextFormField( 
                                                decoration: InputDecoration(labelText:widget.isSell ? "Nombre vendu": "Nombre acheté",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                controller : _nombre,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                keyboardType: TextInputType.number, 
                                                inputFormatters: <TextInputFormatter>[ 
                                                    FilteringTextInputFormatter.digitsOnly,
                                                ], // Only numbers can be entered 
                                                validator : (value){
                                                    if (value == null || value.isEmpty||value=='0'){
                                                        return 'Veuillez entrer un nombre supérieur à 0';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.05),
                                        SizedBox(
                                            width:MediaQuery.of(context).size.width*0.7,
                                            child:TextFormField( 
                                                decoration: InputDecoration(labelText: "Prix Unitaire",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                controller :_prixUnit,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                keyboardType: TextInputType.number, 
                                                inputFormatters: <TextInputFormatter>[ 
                                                    FilteringTextInputFormatter.digitsOnly 
                                                ], // Only numbers can be entered 
                                                validator : (value){
                                                    if (value == null || value.isEmpty||value=='0'){
                                                        return 'Veuillez entrer un nombre supérieur à 0';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                        Text("Compte",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.01),
                                        Container(
                                            width:MediaQuery.of(context).size.width*0.7,
                                            child:DropdownButton<String>(
                                                isExpanded: true,
                                                value: _typeCompte.text.isEmpty
                                                        ? listAccountStock[0]
                                                        :   _typeCompte.text,
                                                icon: const Icon(Icons.arrow_downward),
                                                elevation: 16,
                                                style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                onChanged: (String? value) {
                                                    setState(() {
                                                        _typeCompte.text = value ??'';
                                                    });
                                                },
                                                items: listAccountStock.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value, style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                                    );
                                                }).toList(),
                                            ), 
                                        ),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.05),
                                        SizedBox(
                                            width:MediaQuery.of(context).size.width*0.7,
                                            child:TextFormField( 
                                                decoration: InputDecoration(labelText: "Plateforme",labelStyle:TextStyle(color: Color(int.parse(colors['text1'])))), 
                                                controller :_plateforme,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                            ),
                                        ),
                                        SizedBox(height:MediaQuery.of(context).size.height*0.1),
                                        if (listAccountdebit.length>0)...[
                                            Text("Compte à débiter",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                            SizedBox(height:MediaQuery.of(context).size.height*0.02),
                                            Container(
                                                width:MediaQuery.of(context).size.width*0.7,
                                                child:DropdownButton<Map<String, dynamic>>(
                                                    isExpanded: true,
                                                    value: _compteDebiteAccount.text.isEmpty
                                                        ? {}
                                                        : listAccountdebit?.firstWhere(
                                                            (account) =>
                                                                '${account['bank']} / ${account['account']}' == _compteDebiteAccount.text,
                                                            orElse: () => {},
                                                            ),
                                                    icon: const Icon(Icons.arrow_downward),
                                                    elevation: 16,
                                                    style: TextStyle(color:Color(int.parse(colors['interactive3']))),
                                                    onChanged: (Map<String, dynamic>? value) {
                                                        setState(() {
                                                            if (value != null) {
                                                                _compteDebiteAccount.text = value['account']?.toString() ?? '';
                                                                _compteDebiteBank.text = value['bank']?.toString() ?? '';
                                                            }
                                                        });
                                                    },
                                                    items: listAccountdebit.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> account) {
                                                        return DropdownMenuItem<Map<String, dynamic>>(
                                                            value: account,
                                                            child: Text(
                                                            '${account['bank']} / ${account['account']}',
                                                            style: TextStyle(color: Color(int.parse(colors['text1']))),
                                                            ),
                                                        );
                                                    }).toList(),
                                                ), 
                                            ),
                                        ],
                                    ],
                                    ),
                                ),
                            ],
                            //Réglage de base 
                            SizedBox(height:MediaQuery.of(context).size.height*0.1),
                            if(onLoad==false )
                                ElevatedButton(
                                    onPressed:()=> sendData(),
                                    child: const Text('Envoyer'),
                                    style :ElevatedButton.styleFrom(
                                        backgroundColor: Color(int.parse(colors['interactive3'])), 
                                        foregroundColor: Color(int.parse(colors['text1'])), 
                                        overlayColor: Color(int.parse(colors['interactive1'])),
                                        textStyle: const TextStyle( 
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),
                            SizedBox(height:MediaQuery.of(context).size.height*0.1),
                            if(onLoad==true) const Center(child: CircularProgressIndicator()),
                            if (_errorMessage != null)
                                Center(
                                    child: Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Colors.red),
                                    ),
                                ),
                            SizedBox(height:MediaQuery.of(context).size.height*0.1),
                            if (_responseMessage != null)
                                Center(
                                    child: Text(
                                    _responseMessage!,
                                    style: TextStyle(color: Colors.green),
                                    ),
                                ),
                            SizedBox(height:MediaQuery.of(context).size.height*0.1),
                        ],
                    ),
                    Center(
                        child: Column(
                            children: [
                                Text("Séléctionner un actif",style: TextStyle(color: Color(int.parse(colors['text1'])))),
                                SizedBox(height:MediaQuery.of(context).size.height*0.02),
                                SearchBar.SearchBar(colors:colors, categorie:'bourse',onClick:(Map<String, dynamic> returnValue){
                                    setState(() {
                                    _name.text = returnValue?['company'] ?? ''; // Ajout de la gestion de nullité
                                    _ticker.text = returnValue?['ticker'] ?? '';
                                    if(returnValue?['type'] == 'ETF') _categorie.text = 'ETF';
                                    //gère l'auto remplissage des lists 
                                    _localisation.text = '';
                                    _activite.text = ''; 
                                    industry = <String>['Technologie', 'Santé', 'Finance', 'Énergie', 'Matériaux de base', 'Industrie', 'Consommation cyclique', 'Consommation non cyclique','Télécommunications', 'Immobilier','Services publics','Commodities', 'Gold',''];
                                    country = <String>['Europe','Amérique du Nord','Amérique du sud','Afrique','Asie','Moyen-Orient','Océanie',''];
                                    if(country.contains(returnValue?['country'])) country.remove(returnValue?['country']);
                                    if(returnValue?['country']!=null) country.insert(0, returnValue?['country']);
                                    if(industry.contains(returnValue?['sector'])) industry.remove(returnValue?['sector']);
                                    if(returnValue?['country']!=null) industry.insert(0, returnValue?['sector']);
                                    });
                                }),
                            ],
                        ),
                    ),
                ],
            ),
        );    
    }
}