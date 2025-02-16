import 'package:mywallet_mobile/welcome/service/navigation_service.dart';

class NavigationController {
  NavigationController(this._navigationService);

  final NavigationService _navigationService;

  void navigateToLogin() => _navigationService.goToLogin();
  void navigateToSignUp() => _navigationService.goToSignUp();
}
