import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './svgButton.dart';
import './textButton.dart';
import 'searchBar.dart' as SearchBar; 

class Header extends StatefulWidget {
  final bool isConnect;
  int menu=0;
  bool button = false;

  Header({
    super.key,
    required this.isConnect,
  });

  @override
    State<Header> createState() => _HeaderState();
  }

class _HeaderState extends State<Header> {
  int menu = 0;
  bool button = false;
  bool isReady = false;
  Map<String, dynamic> colors={
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
  };
    
  @override
  void initState() {
        super.initState();
        if (widget.isConnect){
          initializeSettings();
        };
  }

  Future<void> initializeSettings() async {
    // Initialiser SharedPreferences via votre classex
    final prefs = await SharedPreferences.getInstance();
    setState((){
        colors = jsonDecode(prefs.getString('colors').toString()??'');
        isReady = true;
    });
  }

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return !isReady && widget.isConnect ?
            Column( 
                children:[
                  Container(
                    padding : EdgeInsets.only(left:30.0, right:30.0),
                    height: (MediaQuery.of(context).size.height < 685 ? MediaQuery.of(context).size.height*0.15 : MediaQuery.of(context).size.height * 0.1),
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xFF181111),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ]
                    ),
                  ),
                ],
              )
      : 
      Stack(
        children:[
          Column(
            children: [
              Container(               
                padding : EdgeInsets.only(left:30.0, right:30.0),
                height: (MediaQuery.of(context).size.height < 685 ? MediaQuery.of(context).size.height*0.15 : MediaQuery.of(context).size.height * 0.1),
                width: MediaQuery.of(context).size.width,
                color: widget.isConnect ?  Color(int.parse(colors['background1'])) : Color(0xFF181111),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (MediaQuery.of(context).size.width > 550 )  
                      HoverableTextButton(text:'MyWallet.co',
                      color : widget.isConnect ? Color(int.parse(colors['text2'])) : Color(0xFFFBD3CB),
                      hoverColor : widget.isConnect ? Color(int.parse(colors['text1'])): Color(0xFFFF977D),
                      onClick : widget.isConnect ? ()=>navigateTo(context, '/main'):()=>navigateTo(context, '/'),
                      fontSize : 30,),
                    if (MediaQuery.of(context).size.width < 550 && widget.isConnect==false) 
                      HoverableTextButton(text:'MyWallet.co',
                      color :  widget.isConnect ? Color(int.parse(colors['text2'])) :  Color(0xFFFBD3CB),
                      hoverColor :  widget.isConnect ? Color(int.parse(colors['text1'])) :  Color(0xFFFF977D),
                      onClick : widget.isConnect ? ()=>navigateTo(context, '/main'):()=>navigateTo(context, '/'),
                      fontSize : 30,),
                    Row(
                      children: [
                        if (widget.isConnect) ...[
                          if(MediaQuery.of(context).size.width<670)...[
                            SizedBox(
                              width: !button && MediaQuery.of(context).size.width<670 && widget.isConnect ? MediaQuery.of(context).size.width - 60.0 : MediaQuery.of(context).size.height * 0.05,
                              child: Row(
                                children:[
                                  SizedBox(width: !button && MediaQuery.of(context).size.width<670 && widget.isConnect ? MediaQuery.of(context).size.width - 60.0 - MediaQuery.of(context).size.height * 0.05 : 0),
                                  HoverableSvgButton(
                                    svgPath : (button == false ?'assets/more.svg':'assets/less.svg'),
                                    color : widget.isConnect ? Color(int.parse(colors['interactive2'])) : Color(0xFF4E1511),
                                    hoverColor : widget.isConnect ? Color(int.parse(colors['border1'])) : Color(0xFF6E2920),
                                    onClick : () => setState(() {
                                      button = (button == false ? true : false);
                                      menu = (button == false ? 0 : menu);
                                    }), // navigateTo(context, ''),
                                    size : MediaQuery.of(context).size.height * 0.05,
                                    isActive : menu == 0,
                                    activeColor : widget.isConnect ? Color(int.parse(colors['border1'])) : const Color(0xFF6E2920),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (MediaQuery.of(context).size.width>670 || button == true)...[
                          SizedBox(width: (MediaQuery.of(context).size.width < 670 ? (MediaQuery.of(context).size.width < 450 ? MediaQuery.of(context).size.width/8:50 ) :0 )),
                          //SvgPicture.asset('assets/docsLogo.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
                          HoverableSvgButton(
                            svgPath : 'assets/docsLogo.svg',
                            color : widget.isConnect ? Color(int.parse(colors['interactive2'])) : Color(0xFF4E1511),
                            hoverColor : widget.isConnect ? Color(int.parse(colors['border1'])) : Color(0xFF6E2920),
                            onClick : () => setState(() {
                              menu = (menu == 1 ? 0 : 1);
                            }),//navigateTo(context, ''),
                            size : MediaQuery.of(context).size.height * 0.05,
                            isActive : menu == 1,
                            activeColor : widget.isConnect ? Color(int.parse(colors['border1'])) : const Color(0xFF6E2920),
                          ),
                          SizedBox(width: (MediaQuery.of(context).size.width < 550 ? (MediaQuery.of(context).size.width < 450 ? MediaQuery.of(context).size.width/7:MediaQuery.of(context).size.width/6 ):MediaQuery.of(context).size.width < 1024 ? 30 :50)),
                          //SvgPicture.asset('assets/walletlogo.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
                          HoverableSvgButton(
                            svgPath : 'assets/walletlogo.svg',
                            color : widget.isConnect ? Color(int.parse(colors['interactive2'])) : Color(0xFF4E1511),
                            hoverColor : widget.isConnect ? Color(int.parse(colors['border1'])) : Color(0xFF6E2920),
                            onClick : () => setState(() {
                              menu = (menu==2?0:2);
                            }),
                            size : MediaQuery.of(context).size.height * 0.05,
                            isActive : menu == 2,
                            activeColor : widget.isConnect ? Color(int.parse(colors['border1'])) : const Color(0xFF6E2920),
                          ),
                          SizedBox(width: (MediaQuery.of(context).size.width < 550 ? (MediaQuery.of(context).size.width < 450 ? MediaQuery.of(context).size.width/7:MediaQuery.of(context).size.width/6 ): MediaQuery.of(context).size.width < 1024 ? 30 :50)),
                          ],
                        ],
                        //SvgPicture.asset('assets/account.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
                        if ( widget.isConnect==false || MediaQuery.of(context).size.width>670 || button == true)...[
                        HoverableSvgButton(
                            svgPath : 'assets/account.svg',
                            color : widget.isConnect ? Color(int.parse(colors['interactive2'])) : Color(0xFF4E1511),
                            hoverColor : widget.isConnect ? Color(int.parse(colors['border1'])) : Color(0xFF6E2920),
                            onClick : widget.isConnect ? () => setState(() {
                              menu = (menu==3?0:3);
                            }) : ()=>navigateTo(context, '/login'),
                            size : MediaQuery.of(context).size.height * 0.05,
                            isActive : menu == 3,
                            activeColor : widget.isConnect ? Color(int.parse(colors['border1'])) : Color(0xFF6E2920),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding : EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                height: (menu==0 ? 0 : MediaQuery.of(context).size.height*0.05),
                decoration: BoxDecoration(
                  color: widget.isConnect ? Color(int.parse(colors['background1'])) : Color(0xFF181111),
                  border: Border.all(
                    color: widget.isConnect ? Color(int.parse(colors['background1'])) : Color(0xFF181111), 
                    width: 0.0, 
                  ),
                ),
                child:SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FirstButton(menu: menu, colors:colors),
                      _SecondButton(menu: menu, colors:colors),
                      _ThirdButton(menu: menu, colors:colors),
                      _LastButton(menu: menu, colors:colors),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //gestion de la searchbar
          if (widget.isConnect && (MediaQuery.of(context).size.width>670 || button == false))...[
            //Pour tel
            if(widget.isConnect && (MediaQuery.of(context).size.width<670 && button == false))...[
              Container(
                padding : EdgeInsets.only(
                    left:MediaQuery.of(context).size.width * 0.1, 
                    top:MediaQuery.of(context).size.height < 685 ? ((MediaQuery.of(context).size.height*0.15)/2)-(MediaQuery.of(context).size.height * 0.05)+5 : ((MediaQuery.of(context).size.height * 0.1)/2)-(MediaQuery.of(context).size.height * 0.05)+5,
                ),
                child:Column(
                  children: [
                    //Positioned(
                      //top: 0,//MediaQuery.of(context).size.width < 550 ?( MediaQuery.of(context).size.height < 685 ? (MediaQuery.of(context).size.height*0.15 + MediaQuery.of(context).size.height * 0.05)/2 : (MediaQuery.of(context).size.height * 0.1 + MediaQuery.of(context).size.height * 0.05)/2) : 0, 
                      //left: //(MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.3/2)) / 2,
                      //right: 0,
                      //child: 
                      //Column(
                        //children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          //SizedBox(width: (MediaQuery.of(context).size.width < 670 ? (MediaQuery.of(context).size.width < 450 ? MediaQuery.of(context).size.width/8:50 ) :0 )),
                          SearchBar.SearchBar(
                            colors: colors,
                            categorie: 'all',
                            onClick: (Map<String, dynamic> returnValue) {
                              navigateTo(context, '/main');
                            },
                          ),
                        //],
                      //),
                    //),
                  ],
                ),
              ),
            ],
            //Pour ordi
            if(MediaQuery.of(context).size.width>670)...[
              Center(
                child:Column(
                  children: [
                    //Positioned(
                      //top: 0,//MediaQuery.of(context).size.width < 550 ?( MediaQuery.of(context).size.height < 685 ? (MediaQuery.of(context).size.height*0.15 + MediaQuery.of(context).size.height * 0.05)/2 : (MediaQuery.of(context).size.height * 0.1 + MediaQuery.of(context).size.height * 0.05)/2) : 0, 
                      //left: //(MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.3/2)) / 2,
                      //right: 0,
                      //child: 
                      //Column(
                        //children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          //SizedBox(width: (MediaQuery.of(context).size.width < 670 ? (MediaQuery.of(context).size.width < 450 ? MediaQuery.of(context).size.width/8:50 ) :0 )),
                          SearchBar.SearchBar(
                            colors: colors,
                            categorie: 'all',
                            onClick: (Map<String, dynamic> returnValue) {
                              //navigateTo(context, '/asset/${returnValue?['ticker'] ?? ''}');
                              navigateTo(context, '/main');
                            },
                          ),
                        //],
                      //),
                    //),
                  ],
                ),
              ),
            ],
          ],
        ],
      );
  }
}


/*
class SearchBar extends StatelessWidget {
  final Map<String, dynamic> colors; 
  const SearchBar({
    required this.colors,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width:  MediaQuery.of(context).size.width < 550 ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: Color(int.parse(colors['interactive1'])),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/search.svg',color: Color(int.parse(colors['border2']))),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(
                  color : Color(int.parse(colors['text2'])), 
              ),
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                border: InputBorder.none,
                hintStyle: TextStyle( // Style pour le placeholder
                  color: Color(int.parse(colors['text2'])), 
                ),
                contentPadding: EdgeInsets.only(bottom: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

class _FirstButton extends StatelessWidget{
  final Map<String, dynamic> colors; 
  final int menu;

  const _FirstButton ({
    super.key,
    required this.colors,
    required this.menu,
  });

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context){
    String text;
    String path;
    switch (menu) {
      case 1:
        text = "Stratégie";
        path = '';
        break;
      case 2:
        text = "Bourse";
        path = '';
        break;
      case 3:
        text = "Compte";
        path = '/compte';
        break;
      default:
        text = "";
        path = '';
    }
    return Container(
        width : (MediaQuery.of(context).size.width < 670 ? MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width /4),
        decoration: BoxDecoration(border: Border(right: BorderSide(color: Color(int.parse(colors['interactive2']))))),
        child : HoverableTextButton(
          text : text,
          color : Color(int.parse(colors['text2'])),
          hoverColor : Color(int.parse(colors['text1'])),
          onClick : () => navigateTo(context, path),
          fontSize : 20,
      ),
    );
  }
}


class _SecondButton extends StatelessWidget{
  final Map<String, dynamic> colors; 
  final int menu;

  const _SecondButton ({
    super.key,
    required this.colors,
    required this.menu,
  });

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context){
    String text;
    switch (menu) {
      case 1:
        text = "Simu Impôt";
        break;
      case 2:
        text = "Immobilier";
        break;
      case 3:
        text = "Export Csv";
        break;
      default:
        text = "";
    }
    return Container(
      width : (MediaQuery.of(context).size.width < 670 ? MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width /4),
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Color(int.parse(colors['interactive2']))))),
      child : HoverableTextButton(
          text : text,
          color :  Color(int.parse(colors['text2'])) ,
          hoverColor :Color(int.parse(colors['text1'])) ,
          onClick : () => navigateTo(context, ''),
          fontSize : 20,
      ),
    );
  }
}


class _ThirdButton extends StatelessWidget{
  final Map<String, dynamic> colors; 
  final int menu;

  const _ThirdButton ({
    super.key,
    required this.colors,
    required this.menu,
  });

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context){
    String text;
    switch (menu) {
      case 1:
        text = "Ressources";
        break;
      case 2:
        text = "Cryptomonnaie";
        break;
      case 3:
        text = "Contact";
        break;
      default:
        text = "";
    }
    return Container(
      width : (MediaQuery.of(context).size.width < 670 ? MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width /4),
      decoration: BoxDecoration(border: Border(right: BorderSide(color:Color(int.parse(colors['interactive2']))))),
      child : HoverableTextButton(
          text : text,
          color :  Color(int.parse(colors['text2'])),
          hoverColor : Color(int.parse(colors['text1'])),
          onClick : () => navigateTo(context, ''),
          fontSize : 20,
      ),
    );
  }
}


class _LastButton extends StatelessWidget{
  final Map<String, dynamic> colors; 
  final int menu;

  const _LastButton ({
    super.key,
    required this.colors,
    required this.menu,
  });

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context){
    String text;
    String path;
    switch (menu) {
      case 1:
        text = "Comunnauté";
        path = "";
        break;
      case 2:
        text = "Achat / Vente";
        path = "/achat_vente";
        break;
      case 3:
        text = "Déconnexion";
        path = "";
        break;
      default:
        text ="";
        path="";
    }
    return Container(
      width :(MediaQuery.of(context).size.width < 670 ? MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width /4),
      child :HoverableTextButton(
          text : text,
          color :  Color(int.parse(colors['text2'])) ,
          hoverColor :  Color(int.parse(colors['text1'])) ,
          onClick : () => navigateTo(context, path),
          fontSize : 20,
      ),
    );
  }
}
