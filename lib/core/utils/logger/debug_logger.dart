import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class DebugLogger {
  DebugLogger._();
  static void log(String tag, dynamic msg, {Object? error}) {
    if (kDebugMode) {
      developer.log('$msg', time: DateTime.now(), name: tag, error: error);
    }
  }
}
