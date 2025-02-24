import 'package:flutter/material.dart';
import 'package:mywallet_mobile/authentification/domain/service/auth_navigation_service.dart';

class NavigationController {
  final NavigationService _navigationService;
  const NavigationController(this._navigationService);

  void goToLogin(BuildContext context) => _navigationService.goLogin();
  void goToSignup(BuildContext context) => _navigationService.goSignup();
  void goToDashboard(BuildContext context) => _navigationService.goDashboard();
}
