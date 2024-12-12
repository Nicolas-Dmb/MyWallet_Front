import 'dart:async';
import 'package:flutter/material.dart';

class WalletAnimation extends StatefulWidget {
  const WalletAnimation({Key? key}) : super(key: key);

  @override
  State<WalletAnimation> createState() => _WalletAnimationState();
}

class _WalletAnimationState extends State<WalletAnimation> {
  int _currentFrameX = 0;
  int _currentFrameY = 0;
  final int totalX = 18;
  final int totalY = 3;
  final double widthFrame = 321.05;
  final double heightFrame = 331.7;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel(); // Annuler le timer pour éviter les fuites
    super.dispose();
  }

  void _startAnimation() {
    _timer?.cancel(); 
    _timer = Timer.periodic(
      const Duration(milliseconds: 25),
      (timer) {
        setState(() {
          _currentFrameX = _currentFrameX==17?17:_currentFrameX + 1 ;
        });
      },
    );
  }

  void _stopAnimation() {
    _timer?.cancel();
    setState(() {
      _currentFrameX = 0; 
    });
  }

  void _onMouseEnter(double localY) {
    final double tierHeight = heightFrame / 3;

    setState(() {
      if (localY < tierHeight) {
        _currentFrameY = 2;
      } else if (localY < 2 * tierHeight) {
        _currentFrameY = 1; 
      } else {
        _currentFrameY = 0; 
      }
    });
    _startAnimation(); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: SizedBox(
          width: widthFrame,
          height: heightFrame,
          child: Stack(
            children: [
              // Sprite sheet animation
              Positioned(
                left: -_currentFrameX * widthFrame,
                bottom: -_currentFrameY * heightFrame+2,
                child: Image.asset(
                  'assets/walletAnimation.png',
                  width: widthFrame * totalX,
                  height: heightFrame * totalY,
                  fit: BoxFit.none,
                ),
              ),
              // Zones interactives pour la souris
              Positioned.fill(
                child: Column(
                  children: [
                    MouseRegion(
                      onEnter: (_) => _onMouseEnter(0), // Premier tiers
                      onExit: (_) => _stopAnimation(),
                      child: Container(
                        height: heightFrame / 3,
                        color: Colors.transparent,
                      ),
                    ),
                    MouseRegion(
                      onEnter: (_) => _onMouseEnter(heightFrame / 3), // Deuxième tiers
                      onExit: (_) => _stopAnimation(),
                      child: Container(
                        height: heightFrame / 3,
                        color: Colors.transparent,
                      ),
                    ),
                    MouseRegion(
                      onEnter: (_) => _onMouseEnter(2 * heightFrame / 3), // Troisième tiers
                      onExit: (_) => _stopAnimation(),
                      child: Container(
                        height: heightFrame / 3,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
