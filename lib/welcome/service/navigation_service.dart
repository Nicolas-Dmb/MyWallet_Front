import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  final BuildContext _context;
  const NavigationService(this._context);

  void goToLogin() => _context.push('/login');
  void goToSignUp() => _context.push('/signUp');
}
