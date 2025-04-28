import 'package:flutter/material.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

Future<void> walletSnackBar(
  BuildContext context,
  String title,
  String text,
) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: CustomSnackBar(title: title, text: text),
      duration: const Duration(seconds: 3),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    ),
  );
}

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({super.key, required this.title, required this.text});

  final String title;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 4.0),
        child: Material(
          color: Colors.transparent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background2,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                18.0,
                16.0,
                22.0,
                16.0,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        14.0,
                        0.0,
                        0.0,
                        0.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTextStyles.title2),
                          Flexible(
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Text(
                                text,
                                maxLines: 2,
                                style: AppTextStyles.small,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
