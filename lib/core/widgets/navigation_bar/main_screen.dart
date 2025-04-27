import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  final Widget child;
  final String location;

  const MainScreen({super.key, required this.child, required this.location});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static const _documentationLink =
      'lib/core/widgets/navigation_bar/assets/doc_logo.png';
  static const _selectedDocumentationLink =
      'lib/core/widgets/navigation_bar/assets/selected_doc_logo.png';

  static const _walletLink =
      'lib/core/widgets/navigation_bar/assets/wallet_logo.png';
  static const _selectedWalletLink =
      'lib/core/widgets/navigation_bar/assets/selected_wallet_logo.png';

  static const _accountLink =
      'lib/core/widgets/navigation_bar/assets/account_logo.png';
  static const _selectedAccountLink =
      'lib/core/widgets/navigation_bar/assets/selected_account_logo.png';

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/documentation');
        break;
      case 1:
        context.go('/dashboard');
        break;
      case 2:
        context.go('/settings');
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.location.startsWith('/dashboard')) {
      _selectedIndex = 1;
    } else if (widget.location.startsWith('/documentation')) {
      _selectedIndex = 0;
    } else if (widget.location.startsWith('/settings')) {
      _selectedIndex = 2;
    }
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background1,
          boxShadow: [
            BoxShadow(
              color: AppColors.interactive1,
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
            BoxShadow(
              color: AppColors.interactive1,
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: NavigationBar(
              height: 80,
              backgroundColor: AppColors.background1,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              indicatorColor: AppColors.background1,
              destinations: [
                NavigationDestination(
                  icon: Image.asset(
                    _selectedIndex == 0
                        ? _selectedDocumentationLink
                        : _documentationLink,
                    fit: BoxFit.contain,
                    height: 40,
                  ),
                  label: '',
                ),
                NavigationDestination(
                  icon: Image.asset(
                    _selectedIndex == 1 ? _selectedWalletLink : _walletLink,
                    fit: BoxFit.contain,
                    height: 40,
                  ),
                  label: '',
                ),
                NavigationDestination(
                  icon: Image.asset(
                    _selectedIndex == 2 ? _selectedAccountLink : _accountLink,
                    fit: BoxFit.contain,
                    height: 40,
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
