import 'package:flutter/foundation.dart';
import 'package:tutor_app/core/routes/app_router.dart';
import 'package:tutor_app/core/utils/app_logger.dart';

class AppErrorHandler {
  static final AppErrorHandler _instance = AppErrorHandler._internal();
  factory AppErrorHandler() => _instance;
  AppErrorHandler._internal();

  void initialize() {
    PlatformDispatcher.instance.onError = (error, stack) {
      handleError(error, stack, errorType: 'Platform Error');
      return true;
    };
  }

  void handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String errorType = 'Error',
  }) {
    if (kDebugMode) {
      AppLogger.logError('$errorType: $error');
      if (stackTrace != null) print(stackTrace);
    }

    _navigateToErrorScreen(error, stackTrace, errorType);
  }

  void _navigateToErrorScreen(
    dynamic error,
    StackTrace? stackTrace,
    String errorType,
  ) {
    final router = AppRouter.router;

    router.push(
      '/error',
      extra: ErrorData(
        error: error,
        stackTrace: stackTrace,
        errorType: errorType,
      ),
    );
  }
}

class ErrorData {
  final dynamic error;
  final StackTrace? stackTrace;
  final String errorType;

  ErrorData({required this.error, this.stackTrace, required this.errorType});
}

void checkExceptionType(String exceptionString) {
  final errorHandler = AppErrorHandler();

  StackTrace? stackTrace = StackTrace.current;
  String errorType = 'Flutter Error';

  if (exceptionString.contains('HttpException')) {
    errorType = 'Network Error';
  } else if (exceptionString.contains('FormatException')) {
    errorType = 'Format Error';
  } else if (exceptionString.contains('TimeoutException')) {
    errorType = 'Timeout Error';
  }

  errorHandler.handleError(exceptionString, stackTrace, errorType: errorType);
}
