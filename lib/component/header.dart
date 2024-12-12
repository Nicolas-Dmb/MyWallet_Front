import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './svgButton.dart';
import './textButton.dart';

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

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
      Container(
        padding : EdgeInsets.only(left:30.0, right:30.0),
        height: (MediaQuery.of(context).size.height < 685 ? MediaQuery.of(context).size.height*0.15 : MediaQuery.of(context).size.height * 0.1),
        width: MediaQuery.of(context).size.width,
        color: const Color(0xFF181111),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (MediaQuery.of(context).size.width > 550 ) Image.asset('assets/logo.png', width : MediaQuery.of(context).size.width*0.2),
            if (MediaQuery.of(context).size.width < 550 && widget.isConnect==false) Image.asset('assets/logo.png', width : MediaQuery.of(context).size.width*0.5),
            if (widget.isConnect && (MediaQuery.of(context).size.width>670 || button == false)) const SearchBar(),
            Row(
              children: [
                if (widget.isConnect) ...[
                  if(MediaQuery.of(context).size.width<670)...[
                    HoverableSvgButton(
                      svgPath : (button == false ?'assets/more.svg':'assets/less.svg'),
                      color : const Color(0xFF4E1511),
                      hoverColor : const Color(0xFF6E2920),
                      onClick : () => setState(() {
                        button = (button == false ? true : false);
                        menu = (button == false ? 0 : menu);
                      }), // navigateTo(context, ''),
                      size : MediaQuery.of(context).size.height * 0.05,
                      isActive : menu == 0,
                      activeColor : const Color(0xFF6E2920),
                  ),
                  ],
                  if (MediaQuery.of(context).size.width>670 || button == true)...[
                  SizedBox(width: (MediaQuery.of(context).size.width < 670 ? (MediaQuery.of(context).size.width < 450 ? MediaQuery.of(context).size.width/8:50 ) :0 )),
                  //SvgPicture.asset('assets/docsLogo.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
                  HoverableSvgButton(
                    svgPath : 'assets/docsLogo.svg',
                    color : const Color(0xFF4E1511),
                    hoverColor : const Color(0xFF6E2920),
                    onClick : () => setState(() {
                      menu = (menu == 1 ? 0 : 1);
                    }),//navigateTo(context, ''),
                    size : MediaQuery.of(context).size.height * 0.05,
                    isActive : menu == 1,
                    activeColor : const Color(0xFF6E2920),
                  ),
                  SizedBox(width: (MediaQuery.of(context).size.width < 550 ? (MediaQuery.of(context).size.width < 450 ? MediaQuery.of(context).size.width/7:MediaQuery.of(context).size.width/6 ): 50)),
                  //SvgPicture.asset('assets/walletlogo.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
                  HoverableSvgButton(
                    svgPath : 'assets/walletlogo.svg',
                    color : const Color(0xFF4E1511),
                    hoverColor : const Color(0xFF6E2920),
                    onClick : () => setState(() {
                      menu = (menu==2?0:2);
                    }),
                    size : MediaQuery.of(context).size.height * 0.05,
                    isActive : menu == 2,
                    activeColor : const Color(0xFF6E2920),
                  ),
                  SizedBox(width: (MediaQuery.of(context).size.width < 550 ? (MediaQuery.of(context).size.width < 450 ? MediaQuery.of(context).size.width/7:MediaQuery.of(context).size.width/6 ): 50)),
                  ],
                ],
                //SvgPicture.asset('assets/account.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
                if ( widget.isConnect==false || MediaQuery.of(context).size.width>670 || button == true)...[
                HoverableSvgButton(
                    svgPath : 'assets/account.svg',
                    color : const Color(0xFF4E1511),
                    hoverColor : const Color(0xFF6E2920),
                    onClick : widget.isConnect ? () => setState(() {
                      menu = (menu==3?0:3);
                    }) : ()=>navigateTo(context, '/login'),
                    size : MediaQuery.of(context).size.height * 0.05,
                    isActive : menu == 3,
                    activeColor : const Color(0xFF6E2920),
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
          color: const Color(0xFF181111),
          border: Border.all(
            color: const Color(0xFF181111), 
            width: 0.0, 
          ),
        ),
        child:SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _FirstButton(menu: menu),
              _SecondButton(menu: menu),
              _ThirdButton(menu: menu),
              _LastButton(menu: menu),
            ],
          ),
        ),
      ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width:  MediaQuery.of(context).size.width < 550 ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: const Color(0xFF391714),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/search.svg',color: const Color(0xFF853A2D)),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              style: TextStyle(
                color: Color(0xFFFBD3CB),
              ),
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                border: InputBorder.none,
                hintStyle: TextStyle( // Style pour le placeholder
                  color: Color(0xFFFBD3CB), 
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


class _FirstButton extends StatelessWidget{
  final int menu;

  const _FirstButton ({
    super.key,
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
        text = "Stratégie";
        break;
      case 2:
        text = "Bourse";
        break;
      case 3:
        text = "Compte";
        break;
      default:
        text = "";
    }
    return Container(
        width : (MediaQuery.of(context).size.width < 670 ? MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width /4),
        decoration: BoxDecoration(border: Border(right: BorderSide(color:  Color(0xFF4E1511)))),
        child : HoverableTextButton(
          text : text,
          color : Color(0xFFFBD3CB),
          hoverColor : const Color(0xFFFF977D),
          onClick : () => navigateTo(context, ''),
          fontSize : 20,
      ),
    );
  }
}


class _SecondButton extends StatelessWidget{
  final int menu;

  const _SecondButton ({
    super.key,
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
      decoration: BoxDecoration(border: Border(right: BorderSide(color:  Color(0xFF4E1511)))),
      child : HoverableTextButton(
          text : text,
          color : Color(0xFFFBD3CB),
          hoverColor : Color(0xFFFF977D),
          onClick : () => navigateTo(context, ''),
          fontSize : 20,
      ),
    );
  }
}


class _ThirdButton extends StatelessWidget{
  final int menu;

  const _ThirdButton ({
    super.key,
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
      decoration: BoxDecoration(border: Border(right: BorderSide(color:  Color(0xFF4E1511)))),
      child : HoverableTextButton(
          text : text,
          color : Color(0xFFFBD3CB),
          hoverColor : const Color(0xFFFF977D),
          onClick : () => navigateTo(context, ''),
          fontSize : 20,
      ),
    );
  }
}


class _LastButton extends StatelessWidget{
  final int menu;

  const _LastButton ({
    super.key,
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
        text = "Comunnauté";
        break;
      case 2:
        text = "Achat / Vente";
        break;
      case 3:
        text = "Déconnexion";
        break;
      default:
        text ="";
    }
    return Container(
      width :(MediaQuery.of(context).size.width < 670 ? MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.width /4),
      child :HoverableTextButton(
          text : text,
          color : Color(0xFFFBD3CB),
          hoverColor : const Color(0xFFFF977D),
          onClick : () => navigateTo(context, ''),
          fontSize : 20,
      ),
    );
  }
}
