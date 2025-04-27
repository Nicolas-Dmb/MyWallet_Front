import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [Documentation(), DashBoard(), Settings()];
  final List<String> _documentationLink = const [
    'lib/core/widgets/navigation_bar/doc_logo.png',
    'lib/core/widgets/navigation_bar/selected_doc_logo.png',
  ];
  final List<String> _walletLink = const [
    'lib/core/widgets/navigation_bar/wallet_logo.png',
    'lib/core/widgets/navigation_bar/selected_wallet_logo.png',
  ];
  final List<String> _accountLink = const [
    'lib/core/widgets/navigation_bar/account_logo.png',
    'lib/core/widgets/navigation_bar/selected_account_logo.png',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: Image.asset(
              _selectedIndex == 0
                  ? _documentationLink[1]
                  : _documentationLink[0],
            ),
            label: 'Documentation',
          ),
          NavigationDestination(
            icon: Image.asset(
              _selectedIndex == 1 ? _walletLink[1] : _walletLink[0],
            ),
            label: 'DashBoard',
          ),
          NavigationDestination(
            icon: Image.asset(
              _selectedIndex == 2 ? _accountLink[1] : _accountLink[0],
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
