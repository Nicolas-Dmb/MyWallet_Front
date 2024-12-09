import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './svgButton.dart';
class Header extends StatelessWidget {
  final bool isConnect;

  const Header({
    super.key,
    required this.isConnect,
  });

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding : EdgeInsets.only(left:30.0, right:30.0),
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFF181111),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logo.png'),
          if (isConnect) const SearchBar(),
          Row(
            children: [
              if (isConnect) ...[
                //SvgPicture.asset('assets/docsLogo.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
                HoverableSvgButton(
                  svgPath : 'assets/docsLogo.svg',
                  color : const Color(0xFF4E1511),
                  hoverColor : const Color(0xFF6E2920),
                  onClick : () => navigateTo(context, ''),
                  size : MediaQuery.of(context).size.height * 0.05,
                ),
                const SizedBox(width: 50),
                //SvgPicture.asset('assets/walletlogo.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
                 HoverableSvgButton(
                  svgPath : 'assets/walletlogo.svg',
                  color : const Color(0xFF4E1511),
                  hoverColor : const Color(0xFF6E2920),
                  onClick : () => navigateTo(context, ''),
                  size : MediaQuery.of(context).size.height * 0.05,
                ),
                const SizedBox(width: 50),
              ],
              //SvgPicture.asset('assets/account.svg',color: const Color(0xFF4E1511),height:MediaQuery.of(context).size.height * 0.05),
              HoverableSvgButton(
                  svgPath : 'assets/account.svg',
                  color : const Color(0xFF4E1511),
                  hoverColor : const Color(0xFF6E2920),
                  onClick : () => navigateTo(context, ''),
                  size : MediaQuery.of(context).size.height * 0.05,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width * 0.3,
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
