import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'component/header.dart';
import 'component/walletAnimation.dart';

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(isConnect: false),
            const Expanded(
              child: Center(
                child: BodyAccueil(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyAccueil extends StatelessWidget {
  const BodyAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF181111),
      height: double.infinity,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Bienvenu sur My Wallet",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 640 ? 30 : 40,
                  color: const Color(0xFFFBD3CB)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            const WalletAnimation(),
            SliderImage(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }
}

class SliderImage extends StatelessWidget {
  const SliderImage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      child: ImageSlideshow(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        initialPage: 0,
        indicatorColor: const Color(0xFFAC4D39),
        indicatorBackgroundColor: const Color(0xFF4E1511),
        autoPlayInterval: 5000,
        isLoop: true,
        children: [
          Image.asset('assets/presentation1.png'),
          Image.asset('assets/presentation2.png'),
          Image.asset('assets/presentation3.png'),
        ],
      ),
    );
  }
}
