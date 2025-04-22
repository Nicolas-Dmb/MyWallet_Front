import 'package:mywallet_mobile/core/logger/app_logger.dart';
import 'package:mywallet_mobile/features/authentification/auth_barrel.dart';

import 'timer_service.dart';

class AuthSessionService {
  AuthSessionService(this._timerService, this._authRepository);
  final TimerService _timerService;
  final AuthRepositoryContract _authRepository;
  bool _isActive = false;

  void start() {
    _isActive = true;
    _loopRefresh();
  }

  void _stop() {
    _isActive = false;
  }

  Future<void> _loopRefresh() async {
    while (_isActive) {
      await _timerService.sleep(const Duration(minutes: 4));
      if (!_isActive) break;

      final result = await _authRepository.refreshToken();

      result.fold((failure) {
        _stop();
        AppLogger.error('erreur lors du refreshToken', failure);
      }, (value) => null);
    }
  }

  Future<String?> getToken() async {
    final result = await _authRepository.getAccessToken();
    return result.fold((failure) {
      _stop();
      AppLogger.error('erreur lors du getToken', failure);
      return null;
    }, (value) => value);
  }

  Future<String?> getUsername() async {
    final result = await _authRepository.getUsername();
    return result.fold((failure) {
      _stop();
      AppLogger.error('erreur lors du getUsername', failure);
      return null;
    }, (value) => value);
  }

  Future<void> logout() async {
    final result = await _authRepository.logout();
    _stop();
    return result.fold((failure) {
      AppLogger.error('erreur lors du logout', failure);
      return null;
    }, (value) => null);
  }
}
