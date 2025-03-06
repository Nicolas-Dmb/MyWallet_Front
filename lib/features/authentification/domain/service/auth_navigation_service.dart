import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  final BuildContext _context;
  const NavigationService(this._context);

  void goDashboard() => _context.pop('/dashboard');
  void goLogin() => _context.push('/login');
  void goSignup() => _context.push('/signup');
}
