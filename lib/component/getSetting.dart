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
    Map<String, Map<String, String>> nightcolors = {
        'Red':{
            'background1':'0xFF181111',
            'background2':'0xFF1F1513',
            'interactive1':'0xFF391714',
            'interactive2':'0xFF4E1511',
            'interactive3':'0xFF5E1C16',
            'border1':'0xFF6E2920',
            'border2':'0xFF853A2D',
            'border3':'0xFFAC4D39',
            'button1':'0xFFE54D2E',
            'button2':'0xFFEC6142',
            'text1':'0xFFFF977D',
            'text2':'0xFFFBD3CB',
            },
        'Grey':{
            'background1':'0xFF111111',
            'background2':'0xFF191919',
            'interactive1':'0xFF222222',
            'interactive2':'0xFF2A2A2A',
            'interactive3':'0xFF313131',
            'border1':'0xFF3A3A3A',
            'border2':'0xFF484848',
            'border3':'0xFF606060',
            'button1':'0xFF6E6E6E',
            'button2':'0xFF7B7B7B',
            'text1':'0xFFB4B4B4',
            'text2':'0xFFEEEEEE',
            },
        'Pink':{
            'background1':'0xFF191117',
            'background2':'0xFF21121D',
            'interactive1':'0xFF37172F',
            'interactive2':'0xFF4B143D',
            'interactive3':'0xFF591C47',
            'border1':'0xFF692955',
            'border2':'0xFF833869',
            'border3':'0xFFA84885',
            'button1':'0xFFD6409F',
            'button2':'0xFFDE51A8',
            'text1':'0xFFFF8DCC',
            'text2':'0xFFFDD1EA',
            },
        'Purple':{
            'background1':'0xFF18111B',
            'background2':'0xFF1E1523',
            'interactive1':'0xFF301C3B',
            'interactive2':'0xFF3D224E',
            'interactive3':'0xFF48295C',
            'border1':'0xFF54346B',
            'border2':'0xFF734079',
            'border3':'0xFF8457AA',
            'button1':'0xFF8E4EC6',
            'button2':'0xFF9A5CD0',
            'text1':'0xFFD19DFF',
            'text2':'0xFFECD9FA',
            },
        'Blue':{
            'background1':'0xFF11131F',
            'background2':'0xFF141726',
            'interactive1':'0xFF182449',
            'interactive2':'0xFF1D2E62',
            'interactive3':'0xFF303374',
            'border1':'0xFF304384',
            'border2':'0xFF3A4F97',
            'border3':'0xFF435DB1',
            'button1':'0xFF3E63DD',
            'button2':'0xFF5472E4',
            'text1':'0xFF9EB1FF',
            'text2':'0xFFD6E1FF',
            },
        'Green':{
            'background1':'0xFF0E1512',
            'background2':'0xFF121B17',
            'interactive1':'0xFF132D21',
            'interactive2':'0xFF113B29',
            'interactive3':'0xFF174933',
            'border1':'0xFF20573E',
            'border2':'0xFF28684A',
            'border3':'0xFF2F7C57',
            'button1':'0xFF30A46C',
            'button2':'0xFF33B074',
            'text1':'0xFF3DD68C',
            'text2':'0xFFB1F1CB',
            },
        'Brown':{
            'background1':'0xFF121211',
            'background2':'0xFF1B1A17',
            'interactive1':'0xFF24231F',
            'interactive2':'0xFF2D2B26',
            'interactive3':'0xFF38352E',
            'border1':'0xFF444039',
            'border2':'0xFF544F46',
            'border3':'0xFF696256',
            'button1':'0xFF978365',
            'button2':'0xFFA39073',
            'text1':'0xFFCBB99F',
            'text2':'0xFFE8E2D9',
            },
        'Yellow':{
            'background1':'0xFF16120C',
            'background2':'0xFF1D180F',
            'interactive1':'0xFF302008',
            'interactive2':'0xFF3F2700',
            'interactive3':'0xFF4D3000',
            'border1':'0xFF5C3D05',
            'border2':'0xFF714F19',
            'border3':'0xFF8F6424',
            'button1':'0xFFFFC53D',
            'button2':'0xFFFFD60A',
            'text1':'0xFFFFCA16',
            'text2':'0xFFFFE7B3',
            },
        };
    Map<String, Map<String, String>> lightcolors = {
        'Red':{
            'background1':'0xFFFFFCFC',
            'background2':'0xFFFFF8F7',
            'interactive1':'0xFFFEEBE7',
            'interactive2':'0xFFFFDCD3',
            'interactive3':'0xFFFFCDC2',
            'border1':'0xFFFDBDAF',
            'border2':'0xFFF5A898',
            'border3':'0xFFEC8E7B',
            'button1':'0xFFE54D2E',
            'button2':'0xFFDD4425',
            'text1':'0xFFD13415',
            'text2':'0xFF5C271F',
            },
        'Grey':{
            'background1':'0xFFFCFCFC',
            'background2':'0xFFF9F9F9',
            'interactive1':'0xFFF0F0F0',
            'interactive2':'0xFFE8E8E8',
            'interactive3':'0xFFE0E0E0',
            'border1':'0xFFD9D9D9',
            'border2':'0xFFCECECE',
            'border3':'0xFFBBBBBB',
            'button1':'0xFF8D8D8D',
            'button2':'0xFF838383',
            'text1':'0xFF646464',
            'text2':'0xFF202020',
            },
        'Pink':{
            'background1':'0xFFFFFCFD',
            'background2':'0xFFFEF7F9',
            'interactive1':'0xFFFFE9F0',
            'interactive2':'0xFFFEDCE7',
            'interactive3':'0xFFFACEDD',
            'border1':'0xFFF3BED1',
            'border2':'0xFFEAACC3',
            'border3':'0xFFE093B2',
            'button1':'0xFFE93D82',
            'button2':'0xFFDF3478',
            'text1':'0xFFCB1D63',
            'text2':'0xFF621639',
            },
        'Purple':{
            'background1':'0xFFFEFCFE',
            'background2':'0xFFFBF7FE',
            'interactive1':'0xFFF7EDFE',
            'interactive2':'0xFFF2E2FC',
            'interactive3':'0xFFEAD5F9',
            'border1':'0xFFE0C4F4',
            'border2':'0xFFD1AFEC',
            'border3':'0xFFBE93E4',
            'button1':'0xFF8E4EC6',
            'button2':'0xFF8347B9',
            'text1':'0xFF8145B5',
            'text2':'0xFF402060',
            },
        'Blue':{
            'background1':'0xFFFDFDFE',
            'background2':'0xFFF7F9FF',
            'interactive1':'0xFFEDF2FE',
            'interactive2':'0xFFE1E9FF',
            'interactive3':'0xFFD2DEFF',
            'border1':'0xFFC1D0FF',
            'border2':'0xFFABBDF9',
            'border3':'0xFF8DA4EF',
            'button1':'0xFF3E63DD',
            'button2':'0xFF3358D4',
            'text1':'0xFF3A5BC7',
            'text2':'0xFF1F2D5C',
            },
        'Green':{
            'background1':'0xFFFBFEFB',
            'background2':'0xFFF5FBF5',
            'interactive1':'0xFFE9F6E9',
            'interactive2':'0xFFDAF1DB',
            'interactive3':'0xFFC9E8CA',
            'border1':'0xFFB2DDB5',
            'border2':'0xFF94CE9A',
            'border3':'0xFF65BA74',
            'button1':'0xFF46A758',
            'button2':'0xFF3E9B4F',
            'text1':'0xFF2A7E3B',
            'text2':'0xFF203C25',
            },
        'Brown':{
            'background1':'0xFFFDFDFC',
            'background2':'0xFFFAF9F2',
            'interactive1':'0xFFF2F0E7',
            'interactive2':'0xFFEAE6DB',
            'interactive3':'0xFFE1DCCF',
            'border1':'0xFFD8D0BF',
            'border2':'0xFFCBC0AA',
            'border3':'0xFFB9A88D',
            'button1':'0xFF978365',
            'button2':'0xFF8C7A5E',
            'text1':'0xFF71624B',
            'text2':'0xFF3B352B',
            },
        'Yellow':{
            'background1':'0xFFFDFDF9',
            'background2':'0xFFFEFCE9',
            'interactive1':'0xFFFFFAB8',
            'interactive2':'0xFFFFF394',
            'interactive3':'0xFFFFE770',
            'border1':'0xFFF3D768',
            'border2':'0xFFE4C767',
            'border3':'0xFFD5AE39',
            'button1':'0xFFFFE629',
            'button2':'0xFFFFDC00',
            'text1':'0xFF9E6C00',
            'text2':'0xFF473B1F',
            },
        };
    //initialisition de SharedPreferences 
    Future<void> initialize() async {
        prefs = await SharedPreferences.getInstance();
        await checkAccessToken().then((_) {
            if (_accessToken != null) {
                getSetting();
            }
        });
        if (_accessToken == null){
            String nightColorsJson = jsonEncode(nightcolors['Red']);
            await prefs.setString('colors', nightColorsJson?? 'error');
        }
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
                    if(userData['setting']['nightMode']){
                        String nightColorsJson = jsonEncode(nightcolors[userData['setting']['color']?.toString()]);
                        await prefs.setString('colors', nightColorsJson?? 'error');
                    }  else {
                        String nightColorsJson = jsonEncode(lightcolors[userData['setting']['color']?.toString()]);
                        await prefs.setString('colors', nightColorsJson?? 'error');
                    }
                    await prefs.setString('devise', userData['setting']['currency']?.toString()?? 'error');
                    await prefs.setString('nightMode', userData['setting']['nightMode']?.toString()?? 'error');
                }
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