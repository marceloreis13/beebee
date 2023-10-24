// ignore: file_names
import 'package:logger/logger.dart';

class Log {
  static final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 130, // width of the output
      colors: false, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      // printTime: true // Should each log print contain a timestamp
    ),
  );

  static d(String? message) => logger.d(message);
  static i(String? message) => logger.i(message);
  static e(String? message, {Object? error}) => logger.e(message, error: error);
  static f(String? message) => logger.f(message);
}
