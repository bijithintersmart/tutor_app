import 'package:talker_logger/talker_logger.dart';

class AppLogger {
  static final logger = TalkerLogger(
    settings: TalkerLoggerSettings(
      enable: true,
      level: LogLevel.debug,
      colors: {
        LogLevel.warning: AnsiPen()..yellow(),
        LogLevel.error: AnsiPen()..red(),
        LogLevel.debug: AnsiPen()..blue(),
        LogLevel.info: AnsiPen()..green(),
        LogLevel.critical: AnsiPen()..magenta(),
      },
    ),
  );

  static void logError(dynamic error) {
    logger.error("$error");
  }

  static void logWarning(dynamic warning) {
    logger.warning("$warning");
  }

  static void logInfo(dynamic info) {
    logger.info("$info");
  }

  static void logDebug(dynamic debug) {
    logger.debug("$debug");
  }

  static void logCritical(dynamic critical) {
    logger.critical("$critical");
  }

  static void log(dynamic log, {LogLevel? level, AnsiPen? pen}) {
    logger.log(log, level: level, pen: pen);
  }
}
