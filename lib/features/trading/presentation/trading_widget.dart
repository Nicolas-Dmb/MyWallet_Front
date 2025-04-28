import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

class TradingWidget extends StatelessWidget {
  const TradingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SizedBox(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Button(
                  text: 'Achat',
                  onTap:
                      () => {
                        context.push('/dashboard/trading/quizz', extra: true),
                      },
                ),
                SizedBox(height: 50),
                _Button(
                  text: 'Vente',
                  onTap:
                      () => {
                        context.push('/dashboard/trading/quizz', extra: false),
                      },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.button1,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(child: Text(text, style: AppTextStyles.title2)),
      ),
    );
  }
}
