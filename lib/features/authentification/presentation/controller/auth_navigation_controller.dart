import 'package:mywallet_mobile/features/authentification/domain/service/auth_navigation_service.dart';

class AuthNavigationController {
  final NavigationService _navigationService;
  const AuthNavigationController(this._navigationService);

  void goToLogin() => _navigationService.goLogin();
  void goToSignup() => _navigationService.goSignup();
  void goToDashboard() => _navigationService.goDashboard();
}
