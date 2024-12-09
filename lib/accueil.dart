import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'component/header.dart';

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
    final Image presentation = Image.asset('assets/presentation1.png', width:MediaQuery.of(context).size.width * 0.80);
    return Container(
      color : const Color(0xFF181111),
      child : Column(
        children: [
          Row (
            mainAxisAlignment : MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset('assets/arrowLeft.svg',width:MediaQuery.of(context).size.width * 0.05, height:MediaQuery.of(context).size.height * 0.05),
              presentation,
              SvgPicture.asset('assets/arrowRigh.svg',width:MediaQuery.of(context).size.width * 0.05, height:MediaQuery.of(context).size.height * 0.05),
            ],
          )
        ],
      )
    );
  }
}