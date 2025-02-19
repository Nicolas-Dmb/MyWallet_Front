import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  static final Logger _logger = Logger();

  static void log(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  static void error(String message, dynamic error) {
    _logger.e(message, time: DateTime.now(), error: error);
  }
}
