import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'component/header.dart';
import 'component/walletAnimation.dart';

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(isConnect: false),
          Expanded(
            child: Center(
              child: BodyAccueil(),
            ),
          ),
        ],
      ),
    );
  }
}

class BodyAccueil extends StatelessWidget {
  const BodyAccueil ({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      color : const Color(0xFF181111),
      height :double.infinity,
      width : MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child : Column(
          children: [
            Text("Bienvenu sur My Wallet", style: TextStyle(fontSize: MediaQuery.of(context).size.width < 640 ?30:40,color : Color(0xFFFBD3CB)),),
            SizedBox(height:MediaQuery.of(context).size.height*0.05),
            WalletAnimation(),
            SliderImage(),
            SizedBox(height:MediaQuery.of(context).size.height*0.05),
          ],
        ),
      ),
    );
  }
}

class SliderImage extends StatelessWidget {
  @override 
  Widget build(BuildContext context){
    return Container(
      margin : EdgeInsets.only(top:100),
      width:  MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      child:ImageSlideshow(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        initialPage:0,
        indicatorColor: Color(0xFFAC4D39),
        indicatorBackgroundColor: Color(0xFF4E1511),
        children:[
          Image.asset('assets/presentation1.png'),
          Image.asset('assets/presentation2.png'),
          Image.asset('assets/presentation3.png'),
        ],
        autoPlayInterval: 5000,
        isLoop : true,
      ),
    );
  }
}
