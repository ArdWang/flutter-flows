/// Logger Utility - Beautiful colored console output using logger package
///
/// Provides colorful, formatted logging for debugging with the logger package
library;

import 'package:logger/logger.dart';

/// Custom colorful log printer for the console
class ColorfulLogPrinter extends LogPrinter {
  // ANSI color codes
  static const String reset = '\x1B[0m';
  static const String bold = '\x1B[1m';
  static const String dim = '\x1B[2m';

  // Foreground colors
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';

  // Bright colors
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String brightMagenta = '\x1B[95m';
  static const String brightCyan = '\x1B[96m';
  static const String brightWhite = '\x1B[97m';

  // Background colors
  static const String bgBlack = '\x1B[40m';
  static const String bgRed = '\x1B[41m';
  static const String bgGreen = '\x1B[42m';
  static const String bgYellow = '\x1B[43m';
  static const String bgBlue = '\x1B[44m';
  static const String bgMagenta = '\x1B[45m';
  static const String bgCyan = '\x1B[46m';
  static const String bgWhite = '\x1B[47m';

  final bool showTimestamp;
  final bool showColors;

  ColorfulLogPrinter({
    this.showTimestamp = true,
    this.showColors = true,
  });

  @override
  List<String> log(LogEvent event) {
    final emoji = _getEmoji(event.level);
    final color = _getColor(event.level);
    final levelName = _getLevelName(event.level);

    final timestamp = showTimestamp
        ? '$dim[${DateTime.now().toString().substring(11, 19)}]$reset '
        : '';

    final message = _formatMessage(event.message);

    if (showColors) {
      return ['$timestamp$color$bold$emoji $levelName$reset $color$message$reset'];
    } else {
      return ['$timestamp$levelName: $message'];
    }
  }

  String _getEmoji(Level level) {
    switch (level) {
      case Level.trace:
        return '📝';
      case Level.debug:
        return '🐛';
      case Level.info:
        return 'ℹ️';
      case Level.warning:
        return '⚠️';
      case Level.error:
        return '❌';
      case Level.fatal:
        return '💀';
      default:
        return '📝';
    }
  }

  String _getColor(Level level) {
    switch (level) {
      case Level.trace:
        return dim;
      case Level.debug:
        return brightMagenta;
      case Level.info:
        return brightBlue;
      case Level.warning:
        return brightYellow;
      case Level.error:
        return brightRed;
      case Level.fatal:
        return bgRed + white + bold;
      default:
        return white;
    }
  }

  String _getLevelName(Level level) {
    switch (level) {
      case Level.trace:
        return 'TRACE';
      case Level.debug:
        return 'DEBUG';
      case Level.info:
        return 'INFO';
      case Level.warning:
        return 'WARN';
      case Level.error:
        return 'ERROR';
      case Level.fatal:
        return 'FATAL';
      default:
        return 'LOG';
    }
  }

  String _formatMessage(dynamic message) {
    if (message is String) {
      return message;
    }
    return message.toString();
  }
}

/// Pretty logger utility for colorful console output
class PrettyLogger {
  static Logger? _instance;

  /// Get or create the logger instance
  static Logger get instance {
    _instance ??= Logger(
      printer: ColorfulLogPrinter(),
      level: Level.trace,
    );
    return _instance!;
  }

  /// Print a header message
  static void header(String message) {
    final separator = '═' * 60;
    instance.d('');
    instance.d(separator);
    instance.d('  $message');
    instance.d(separator);
  }

  /// Print a success message
  static void success(String message) {
    instance.i('✅ $message');
  }

  /// Print an info message
  static void info(String message) {
    instance.i(message);
  }

  /// Print a warning message
  static void warning(String message) {
    instance.w(message);
  }

  /// Print an error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    instance.e(message, error: error, stackTrace: stackTrace);
  }

  /// Print a debug message
  static void debug(String message) {
    instance.d(message);
  }

  /// Print a trace message
  static void trace(String message) {
    instance.t(message);
  }

  /// Print a data/value pair
  static void data(String label, dynamic value) {
    instance.d('├─ $label: $value');
  }

  /// Print a section divider
  static void divider([String text = '']) {
    final line = '─' * 60;
    if (text.isEmpty) {
      instance.d(line);
    } else {
      instance.d('─ $text ${String.fromCharCodes(Iterable.generate(57 - text.length, (_) => '─'.codeUnitAt(0)))}');
    }
  }

  /// Print a boxed message
  static void box(String message) {
    final lines = message.split('\n');
    final maxLength = lines.fold<int>(
      0,
      (max, line) => line.length > max ? line.length : max,
    );
    final border = '═' * (maxLength + 4);

    instance.d('╔$border╗');
    for (final line in lines) {
      final padding = maxLength - line.length;
      instance.d('║  $line${' ' * padding}  ║');
    }
    instance.d('╚$border╝');
  }

  /// Print a list with bullets
  static void list(List<String> items) {
    for (final item in items) {
      instance.d('├─ • $item');
    }
  }

  /// Print a key-value map
  static void map(Map<String, dynamic> data, {String title = ''}) {
    if (title.isNotEmpty) {
      divider(title);
    }
    data.forEach((key, value) {
      PrettyLogger.data(key, value);
    });
  }

  /// Create a custom logger with specific configuration
  static Logger create({
    Level level = Level.trace,
    bool showColors = true,
    bool showTimestamp = true,
  }) {
    return Logger(
      printer: ColorfulLogPrinter(
        showColors: showColors,
        showTimestamp: showTimestamp,
      ),
      level: level,
    );
  }
}
