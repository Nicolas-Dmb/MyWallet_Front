import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'component/header.dart';

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(isConnect: true),
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
      child : Column(
        children: [
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SliderImage(),
            ],
          )
        ],
      )
    );
  }
}

class SliderImage extends StatelessWidget {
  @override 
  Widget build(BuildContext context){
    return Container(
      margin : EdgeInsets.only(top:150),
      width:  MediaQuery.of(context).size.width*0.5,
      height: MediaQuery.of(context).size.height * 0.5,
      child:ImageSlideshow(
        width: double.infinity,
        height: MediaQuery.of(context).size.height *0.5,
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

/*

Widget ImageShadow(String path, BuildContext context){
    return DropShadowImage(
      offset: Offset(30,30),
      scale: 1,
      blurRadius: 12,
      borderRadius: 20,
      image: Image.asset(path),
    );
  }


return Container(
      alignment: Alignment.center,
      margin : EdgeInsets.only(right:50,),
      padding : EdgeInsets.only(right:50,),
      width : MediaQuery.of(context).size.width*0.5,
      height : MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4E1511), 
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Image.asset(
        width : MediaQuery.of(context).size.width*0.45,
        height : MediaQuery.of(context).size.height * 0.45,
        path,
        fit: BoxFit.contain,
      ),
    );*/