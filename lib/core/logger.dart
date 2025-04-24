import 'dart:io';

enum LogLevel { info, success, warning, error }

class Logger {
  static final Logger _instance = Logger._internal();

  factory Logger() {
    return _instance;
  }

  Logger._internal();

  void log(String message, {LogLevel level = LogLevel.info}) {
    final prefix = _getPrefix(level);
    final color = _getColor(level);
    final reset = '\x1B[0m';

    stdout.writeln('$color$prefix$message$reset');
  }

  void info(String message) => log(message, level: LogLevel.info);
  void success(String message) => log(message, level: LogLevel.success);
  void warning(String message) => log(message, level: LogLevel.warning);
  void error(String message) => log(message, level: LogLevel.error);

  String _getPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 'ℹ️  ';
      case LogLevel.success:
        return '✅ ';
      case LogLevel.warning:
        return '⚠️ ';
      case LogLevel.error:
        return '❌ ';
    }
  }

  String _getColor(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return '\x1B[34m'; // Blue
      case LogLevel.success:
        return '\x1B[32m'; // Green
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
    }
  }

}
