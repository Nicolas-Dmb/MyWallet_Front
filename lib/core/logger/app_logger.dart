import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  final Logger _logger = Logger();

  void log(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  void error(String message, dynamic error) {
    _logger.e(message, time: DateTime.now(), error: error);
  }
}
