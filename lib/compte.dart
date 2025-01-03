import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'component/listButton.dart';
import 'component/tokenManager.dart';
import 'component/header.dart';
import 'component/lineChart.dart';
import 'component/textButton.dart';
import 'component/getSetting.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingPage extends StatelessWidget{
    SettingPage({super.key});

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
                DataAccount(),
                DataSetting(),
                ],
            ),
            ),
        ),
        ],
    ),
    );
    }
}

class DataAccount extends StatefulWidget{
    const DataAccount({Key? key}):super(key:key);

    @override
    State<DataAccount> createState() => _DataAccountState();
}

class _DataAccountState extends State<DataAccount>{
    final FlutterSecureStorage storage = FlutterSecureStorage();
    final GetSettingAccount settings = GetSettingAccount();
    String? _accessToken;
    final _formKey = GlobalKey<FormState>();
    bool _modif = false;
    String? _errorMessage; 
    bool onLoad = true;
    String? _id;
    bool isReady = false;
    late Map<String, dynamic> colors;  

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

    @override
    void initState() {
        super.initState();
        checkAccessToken(context).then((_) {
            if (_accessToken != null) {
            _getSetting();
            }
        });
        initializeSettings();
    }

    Future<void> initializeSettings() async {
        // Initialiser SharedPreferences via votre classex
        final prefs = await SharedPreferences.getInstance();
        setState((){
            colors = jsonDecode(prefs.getString('colors').toString()??'');
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
    }

    //Call Setting data
    Future<void> _getSetting() async{
        setState((){
                onLoad=true;
        });
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

                    setState(() {
                    _username.text = userData['username']?.toString() ?? '';
                    _nom.text = userData['last_name']?.toString() ?? '';
                    _prenom.text = userData['first_name']?.toString() ?? '';
                    _email.text = userData['email']?.toString() ?? '';
                    _tel.text = userData['phone']?.toString() ?? '';
                    _pays.text = userData['country']?.toString() ?? '';
                    _profession.text = userData['job']?.toString() ?? '';
                    _revenus.text = userData['income']?.toString() ?? '';
                    _dateBirth = userData['birthday'] != null
                        ? DateTime.tryParse(userData['birthday'].toString())
                        : null;
                    });
                    _id = userData['setting']['user']?.toString() ?? '';
                }
            }else{
                setState((){
                    _errorMessage = "Error : ${response.statusCode}";
                });
            };
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la récupération des données.${e}";
            });
        }finally{
            if (mounted) { // Vérifie que le widget est toujours dans l'arbre
                setState(() {
                    onLoad = false;
                });
            }
        }
        await Future.delayed(Duration(milliseconds: 200));
    }

    //Call Account data 
    Future<void> _setSetting() async{
        setState((){
                onLoad=true;
        });
        final formattedDate = _dateBirth != null
            ? "${_dateBirth!.year.toString().padLeft(4, '0')}-${_dateBirth!.month.toString().padLeft(2, '0')}-${_dateBirth!.day.toString().padLeft(2, '0')}"
            : '';
        checkAccessToken(context);
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/user/${_id}/");
        try{
            final response = await http.patch(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
                body:json.encode({
                    'username': _username.text,
                    'last_name' : _nom.text,
                    'first_name' : _prenom.text,
                    'email' : _email.text,
                    'phone' : _tel.text,
                    'country' : _pays.text,
                    'job' : _profession.text,
                    'income' : _revenus.text,
                    'birthday' : formattedDate,
                }),
            );
            if (response.statusCode==200){
                final responseData = json.decode(response.body);
                setState(() {
                    _modif = false;
                });
                await settings.initialize();
            }else{
                final responseData = json.decode(response.body);
                setState((){
                    _errorMessage = "Error : ${responseData}";
                });
            }
        }catch (e){
            setState((){
                _errorMessage = "Error : Une erreur s'est produite lors de la mise à jour des données.${e}";
            });
        }finally{
            setState((){
                onLoad=false;
            });
        }
    }

    //Call OTP modif account

    @override
    Widget build(BuildContext contex){
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
            ) :Container(
            color: Color(int.parse(colors['background1'])),
            //height : double.infinity,
            padding : EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 700 ?  MediaQuery.of(context).size.width*0.1 : MediaQuery.of(context).size.width*0.05,
                vertical:MediaQuery.of(context).size.height*0.05,
            ),
            child : Column(
                children:[
                    Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children:[
                        Text(
                            'Informations',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                            fontFamily: 'TANNIMBUS',
                            color: Color(int.parse(colors['text2'])), 
                            fontSize: MediaQuery.of(context).size.width<500 ? 15: 20,
                            ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*0.3),
                        onLoad==true ?
                        const Center(child: CircularProgressIndicator()) 
                        : ElevatedButton(
                                onPressed: () {
                                    setState(() {
                                        _modif = !_modif;
                                    });
                                },
                                child: const Text('Modifier'),
                                style :ElevatedButton.styleFrom(
                                    backgroundColor: Color(int.parse(colors['interactive3'])), 
                                    foregroundColor: Color(int.parse(colors['text1'])), 
                                    overlayColor: Color(int.parse(colors['interactive1'])),
                                    textStyle: const TextStyle( 
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                        ),
                        ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.1),
                    Form(
                        key : _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    child : TextFormField(
                                        readOnly : !_modif,
                                        controller : _username,
                                        style : TextStyle(color: Color(int.parse(colors['text2']))),
                                        decoration : const InputDecoration(labelText: 'Identifiant'),
                                        validator : (value){
                                            if (value == null || value.isEmpty){
                                                return 'Veuillez entrer un Identifiant';
                                            }
                                            return null;
                                        },
                                    ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                    children:[
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child : TextFormField(
                                                readOnly : !_modif,
                                                controller : _nom,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                decoration : const InputDecoration(labelText: 'Nom'),
                                                validator : (value){
                                                    if (value == null || value.isEmpty){
                                                    return 'Veuillez entrer votre Identifiant';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width>700 ? MediaQuery.of(context).size.width*0.2:MediaQuery.of(context).size.width*0.05),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child : TextFormField(
                                                readOnly : !_modif,
                                                controller : _prenom,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                decoration : const InputDecoration(labelText: 'Prénom'),
                                                validator : (value){
                                                    if (value == null || value.isEmpty){
                                                    return 'Veuillez entrer votre Identifiant';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                    ]
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                    children:[
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child : TextFormField(
                                                readOnly : !_modif,
                                                controller : _email,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
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
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width>700 ? MediaQuery.of(context).size.width*0.2:MediaQuery.of(context).size.width*0.05),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child :TextFormField(
                                                readOnly : !_modif,
                                                controller : _tel,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                decoration : const InputDecoration(labelText: 'Téléphone'),
                                                validator : (value){
                                                    if (value == null || value.isEmpty){
                                                    return 'Veuillez entrer votre Identifiant';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                    children:[
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child : TextFormField(
                                                readOnly : !_modif,
                                                controller : _pays,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                decoration : const InputDecoration(labelText: 'Pays'),
                                                validator : (value){
                                                    if (value == null || value.isEmpty){
                                                    return 'Veuillez entrer votre Identifiant';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width>700 ? MediaQuery.of(context).size.width*0.2:MediaQuery.of(context).size.width*0.05),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child : TextFormField(
                                                readOnly : !_modif,
                                                controller : _profession,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                decoration : const InputDecoration(labelText: 'Profession'),
                                                validator : (value){
                                                    if (value == null || value.isEmpty){
                                                    return 'Veuillez entrer votre Identifiant';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                                Row(
                                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                    children:[
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            child : TextFormField(
                                                readOnly : !_modif,
                                                controller : _revenus,
                                                style : TextStyle(color: Color(int.parse(colors['text2']))),
                                                decoration : const InputDecoration(labelText: 'Revenus'),
                                                validator : (value){
                                                    if (value == null || value.isEmpty){
                                                    return 'Veuillez entrer votre Identifiant';
                                                    }
                                                    return null;
                                                },
                                            ),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width>700 ? MediaQuery.of(context).size.width*0.2:MediaQuery.of(context).size.width*0.05),
                                        SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child : MediaQuery.of(context).size.width > 770
                                            ?  Row(
                                            mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                            children:[
                                                Center(
                                                    child: Text('Date de naissance :', style: TextStyle(color: Color(int.parse(colors['text2']))),),
                                                ),
                                                
                                                ElevatedButton(
                                                    onPressed: () async {
                                                        final selectedDate = await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime.now(),
                                                            firstDate: DateTime(1930),
                                                            lastDate: DateTime.now(),
                                                        );
                                                        if (selectedDate != null) {
                                                            setState(() {
                                                            _dateBirth = selectedDate;
                                                            });
                                                        }
                                                    },
                                                    child: Text(_dateBirth == null ? 'Select date':"${_dateBirth!.year.toString().padLeft(4, '0')}-${_dateBirth!.month.toString().padLeft(2, '0')}-${_dateBirth!.day.toString().padLeft(2, '0')}"),
                                                ),
                                            ],
                                            )
                                        
                                            : Column(
                                            mainAxisAlignment : MainAxisAlignment.spaceBetween,
                                            children:[
                                                Center(
                                                    child: Text('Date de naissance :', style: TextStyle(color: Color(int.parse(colors['text2']))),),
                                                ),
                                                
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
                                                    child: Text(_dateBirth == null ? 'Select date':"${_dateBirth!.year.toString().padLeft(4, '0')}-${_dateBirth!.month.toString().padLeft(2, '0')}-${_dateBirth!.day.toString().padLeft(2, '0')}"),
                                                ),
                                            ],
                                            ),
                                        ),
                                    ],
                                ),
                                if( _modif &&  onLoad==false )
                                    ElevatedButton(
                                        onPressed:()=> _setSetting(),
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
                                if (_errorMessage != null)
                                   Center(
                                        child: Text(
                                        _errorMessage!,
                                        style: TextStyle(color: Colors.red),
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

class DataSetting extends StatefulWidget{
    const DataSetting({super.key});
  
    @override
    State<DataSetting> createState() => DataSettingState();
}
class DataSettingState extends State<DataSetting>{
    final FlutterSecureStorage storage = FlutterSecureStorage();
    final GetSettingAccount settings = GetSettingAccount();
    String? _accessToken;
    final _formKey = GlobalKey<FormState>();
    bool _modif = false;
    String? _errorMessage; 
    bool isReady = false;
    late Map<String, dynamic> colors;  
    bool onLoad = true;
    String? nightMode;
    String? id;
    List<String> choices = [
        'Grey', 
        'Red', 
        'Pink', 
        'Purple', 
        'Blue', 
        'Green', 
        'Brown', 
        'Yellow', 
    ];
    List<String> choicesDevise = [
        'Euro', 
        'Dollar',
    ];

    final TextEditingController _device = TextEditingController();
    final TextEditingController _nightMode =  TextEditingController();
    final TextEditingController _color = TextEditingController();

    @override
    void initState() {
        super.initState();
        checkAccessToken(context).then((_) {
            if (_accessToken != null) {
            getSetting();
            }
        });
        initializeSettings();
    }

    Future<void> initializeSettings() async {
        // Initialiser SharedPreferences via votre classex
        final prefs = await SharedPreferences.getInstance();
        setState((){
            colors = jsonDecode(prefs.getString('colors').toString()??'');
            nightMode = prefs.getString('nightMode').toString()??'';
            isReady = true;
        });
    }

    @override
    void dispose(){
        _device.dispose();
        _nightMode.dispose();
        _color.dispose();
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

    //getSetting
    Future<void> getSetting() async{
        setState((){
            onLoad=true;
        });
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/setting/");
        try{
            final response = await http.get(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
            );
            if (response.statusCode == 200){
                final List<dynamic> responseData = json.decode(response.body);

                if (responseData.isNotEmpty) {
                    final dataResponse = responseData[0];
                    setState((){
                        _device.text = dataResponse['currency'].toString() ?? '';
                        _nightMode.text = dataResponse['nightMode'].toString() ?? '';
                        _color.text = dataResponse['color'].toString() ?? '';
                        id = dataResponse['id'].toString() ?? '';
                    });
                }
            }else{
                setState((){
                    _errorMessage = "Error : ${response.statusCode}";
                });
            }
        }catch (e){
            setState((){
                    _errorMessage = "Error : Une erreur s'est produite lors de la récupération des données Setting ${e}";
                });
        }finally{
            if (mounted) { 
                setState(() {
                    onLoad = false;
                });
            }
        }
        await Future.delayed(Duration(milliseconds: 200));
    }

    //setSetting
    Future<void> setSetting() async{
        setState((){
            onLoad=true;
        });
        checkAccessToken(context);
        final url = Uri.parse("https://mywalletapi-502906a76c4f.herokuapp.com/api/setting/$id/");
        try{
            final response = await http.patch(
                url,
                headers:{
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${_accessToken}',
                },
                body:json.encode({
                        'currency':_device.text,
                        'nightMode':_nightMode.text,
                        'color':_color.text,
                }),
            );
            if(response.statusCode == 200){
                final dataResponse = json.decode(response.body);
                setState((){
                    _modif=false;
                });
                await settings.initialize();
                Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                        Navigator.pushReplacementNamed(context, '/compte'); // Lancer l'initialisation après 1 seconde
                    });
                });
            }else{
                setState((){
                    _errorMessage = "Error : ${response}";
                });
            }
        }catch (e){
            setState((){
                    _errorMessage = "Error : Une erreur s'est produite lors des modifications des données Setting ${e}";
                });
        }finally{
            setState((){
                onLoad=false;
            });
        }
    }

    @override
    Widget build(BuildContext context){
        return _color.text.isEmpty || !isReady
            ? CircularProgressIndicator()
            :Container(
            color: Color(int.parse(colors['background1'])),
            //height : double.infinity,
            padding : EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 700 ?  MediaQuery.of(context).size.width*0.1 : MediaQuery.of(context).size.width*0.05,
                vertical:MediaQuery.of(context).size.height*0.05,
            ),
            width: MediaQuery.of(context).size.width,
            child : Column( 
                children:[
                    Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children:[
                            Text(
                                'Affichage',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'TANNIMBUS',
                                    color: Color(int.parse(colors['text2'])), 
                                    fontSize: 20,
                                ),
                            ),
                            onLoad==true ?
                            const Center(child: CircularProgressIndicator()) 
                            : ElevatedButton(
                                onPressed: () {
                                    setState(() {
                                        _modif = !_modif;
                                    });
                                },
                                child: const Text('Modifier'),
                                style :ElevatedButton.styleFrom(
                                    backgroundColor: Color(int.parse(colors['interactive3'])), 
                                    foregroundColor: Color(int.parse(colors['text1'])), 
                                    overlayColor: Color(int.parse(colors['interactive1'])),
                                    textStyle: const TextStyle( 
                                    fontWeight: FontWeight.bold,
                                    ),
                                ),
                            ),
                        ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.1),
                    Form(
                        key : _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text("Background color :", style: TextStyle(color: Color(int.parse(colors['text2'])),),),
                                //Color
                                InlineScrollableX(
                                    choices:_modif? choices:[_color.text],
                                    defaultValue: _color.text,
                                    onClick: _modif? (selectedValue) {
                                    setState(() {
                                        _color.text = selectedValue; //permet de mettre a jour color.text
                                    });
                                    }:(selectedValue) {
                                        _color.text = _color.text;
                                    },
                                    modif : _modif,
                                    textColor: int.parse(colors['text1']),
                                    color:nightMode=='true'?int.parse(colors['interactive3']):int.parse(colors['interactive1']),
                                    activeColor:nightMode=='true'?int.parse(colors['interactive1']):int.parse(colors['interactive3']),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                                //NightMode
                                Text("NightMode :",style: TextStyle(color: Color(int.parse(colors['text2'])),),),
                                Switch(
                                    activeColor:nightMode=='true'?Color(int.parse(colors['interactive1'])):Color(int.parse(colors['interactive3'])),
                                    inactiveThumbColor:nightMode=='true'?Color(int.parse(colors['interactive3'])):Color(int.parse(colors['interactive1'])),
                                    value: _nightMode.text=='true'?true:false,
                                    onChanged: _modif ? (value) {
                                    setState(() {
                                        _nightMode.text = _nightMode.text=='true'?'false':'true';
                                    });
                                    }: (value) {
                                    setState(() {
                                        _nightMode.text = _nightMode.text;
                                    });
                                    },
                                ),
                                SizedBox(height: MediaQuery.of(context).size.width*0.1),
                                //Devise
                                Text("Devise :",style: TextStyle(color: Color(int.parse(colors['text2'])),),),
                                InlineScrollableX(
                                    choices: _modif? choicesDevise : [_device.text],
                                    defaultValue: _device.text,
                                    onClick: _modif ? (selectedValue) {
                                    setState(() {
                                        _device.text = selectedValue; //permet de mettre a jour color.text
                                    });
                                    }:(selectedValue) {
                                        _device.text=_device.text;
                                    },
                                    modif : _modif,
                                    textColor: int.parse(colors['text1']),
                                    color: nightMode=='true'?int.parse(colors['interactive3']):int.parse(colors['interactive1']),
                                    activeColor:nightMode=='true'?int.parse(colors['interactive1']):int.parse(colors['interactive3']),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                                if( _modif &&  onLoad==false )
                                    ElevatedButton(
                                        onPressed:()=> setSetting(),
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
                                if (_errorMessage != null)
                                   Center(
                                        child: Text(
                                        _errorMessage!,
                                        style: TextStyle(color: Colors.red),
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