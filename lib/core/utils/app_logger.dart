import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void info(String message) {
    if (kDebugMode) _logger.i(message);
  }

  static void warn(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  static void debug(String message) {
    if (kDebugMode) _logger.d(message);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static void success(String message) {
    if (kDebugMode) _logger.i('✅ $message');
  }
}
