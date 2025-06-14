import 'dart:async';
import 'dart:io';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/core/routes/app_router.dart';
import 'package:tutor_app/core/utils/app_logger.dart';
import 'package:tutor_app/core/utils/local_storage.dart';

Future<void> initializeAppConfig() async {
  await dotenv.load(fileName: ".env");
  await SupabaseClientService.initialize(
    url: dotenv.get("DB_URL", fallback: ""),
    anonKey: dotenv.get("ANON_KEY", fallback: ""),
  );
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(statusBarColor: AppColors.primary),
  // );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  await GlobalLocalStorage().init();
}

double getDeviceWidth(context) {
  return MediaQuery.of(context).size.width;
}

double getDeviceHeight(context) {
  return MediaQuery.of(context).size.height;
}

Future<bool?> showToast(
  String msg, {
  Toast? toastLength,
  double? fontSize,
  String? fontAsset,
  ToastGravity? gravity,
  Color? backgroundColor,
  Color? textColor,
}) async {
  await Fluttertoast.cancel();
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.black,
    textColor:Colors.white,
  );
}

int getRandomInteger({int max = 999}) {
  return Random().nextInt(max);
}

TimeOfDay stringToTimeOfDay(String timeString) {
  try {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  } catch (e) {
    return const TimeOfDay(hour: 0, minute: 0);
  }
}

bool isSameDay(DateTime? dateA, DateTime? dateB) {
  return dateA?.year == dateB?.year &&
      dateA?.month == dateB?.month &&
      dateA?.day == dateB?.day;
}

void checkExceptionType(Object exception, {dynamic stackTrace}) {
  if (exception is HttpException) {
    AppLogger.logError("HttpException: ${exception.message}");
  } else if (exception is SocketException) {
    AppLogger.logCritical("SocketException: ${exception.message}");
  } else if (exception is ArgumentError) {
    AppLogger.logError(
      "ArgumentError: ${exception.message}\n Stack Trace${exception.stackTrace}",
    );
  } else if (exception is AssertionError) {
    AppLogger.logError(
      "AssertionError: ${exception.message}\n Stack Trace${exception.stackTrace}",
    );
  } else if (exception is ConcurrentModificationError) {
    AppLogger.logError("ConcurrentModificationError");
  } else if (exception is RangeError) {
    AppLogger.logDebug(
      "RangeError: ${exception.message}\n Stack Trace${exception.stackTrace}",
    );
  } else if (exception is StateError) {
    AppLogger.logError(
      "StateError: ${exception.message}\n Stack Trace${exception.stackTrace}",
    );
  } else if (exception is UnsupportedError) {
    AppLogger.logError(
      "UnsupportedError: ${exception.message}\n Stack Trace${exception.stackTrace}",
    );
  } else if (exception is IOException) {
    AppLogger.logError("IOException: $exception");
  } else if (exception is TimeoutException) {
    AppLogger.logError("TimeoutException: ${exception.message}");
  } else if (exception is PlatformException) {
    AppLogger.logError(
      "PlatformException: code=${exception.code}, message=${exception.message}, details=${exception.details}",
    );
  } else {
    AppLogger.logCritical(
      "Unhandled Exception: ${exception.toString()}\nStack Trace: $stackTrace",
    );
  }
}

String getExceptionType(Object exception, {dynamic stackTrace}) {
  if (exception is HttpException) {
    return "HttpException";
  } else if (exception is SocketException) {
    return "SocketException";
  } else if (exception is ArgumentError) {
    return "ArgumentError";
  } else if (exception is AssertionError) {
    return "AssertionError";
  } else if (exception is ConcurrentModificationError) {
    return "ConcurrentModificationError";
  } else if (exception is RangeError) {
    return "RangeError";
  } else if (exception is StateError) {
    return "StateError";
  } else if (exception is UnsupportedError) {
    return "UnsupportedError";
  } else if (exception is IOException) {
    return "IOException";
  } else if (exception is TimeoutException) {
    return "TimeoutException";
  } else if (exception is PlatformException) {
    return "PlatformException";
  } else {
    return "Unhandled Exception";
  }
}

String getMessageFromResCode(int responseCode) {
  switch (responseCode) {
    case 400:
      return "We encountered an issue processing your request. The information you provided appears to be incorrect or incomplete. Please double-check your input and try submitting again. If the problem persists, contact our support team. (Error: 400)";
    case 401:
      return "Authentication failed. Your current session has expired or you are not logged in. Please sign in with your account credentials to regain access. Ensure you are using the correct username and password. (Error: 401)";
    case 403:
      return "Access denied. You do not have the necessary permissions to view or interact with this resource. This may be due to your account type or current access level. Please contact your system administrator for further assistance. (Error: 403)";
    case 404:
      return "The requested resource could not be found. It's possible the item has been removed, renamed, or is temporarily unavailable. Please verify the information and try your request again. If you believe this is an error, contact our support team. (Error: 404)";
    case 429:
      return "Too many requests detected. To protect our system and ensure fair usage, we've temporarily limited your access. Please wait a few moments before attempting your request again. Repeated attempts may result in extended restrictions. (Error: 429)";
    case 500:
      return "An internal server error has occurred. Our technical team has been automatically notified and is working to resolve the issue. We apologize for the inconvenience. Please try your request again in a few minutes. (Error: 500)";
    case 503:
      return "Service is currently unavailable due to maintenance or unexpected system load. We are working diligently to restore full functionality as quickly as possible. Please check back shortly or try again later. (Error: 503)";
    default:
      return "An unexpected error has interrupted your request. Our system has logged this incident for further investigation. We apologize for the inconvenience and recommend trying your action again. If the problem continues, please contact our support team with any additional details. (Error: $responseCode)";
  }
}

String getLastAppRoute() {
  final RouteMatch lastMatch =
      AppRouter.router.routerDelegate.currentConfiguration.last;
  final RouteMatchList matchList =
      lastMatch is ImperativeRouteMatch
          ? lastMatch.matches
          : AppRouter.router.routerDelegate.currentConfiguration;
  final String location = matchList.uri.toString();
  return location;
}

void scaffoldToast(
  String message, {
  Widget? content,
  Color? backgroundColor,
  SnackBarBehavior? behavior,
  SnackBarAction? action,
  Duration? duration,
}) {
  ScaffoldMessenger.of(AppRouter.rootNavigatorKey.currentContext!).showSnackBar(
    SnackBar(
      duration: duration ?? Duration(seconds: 4),
      dismissDirection: DismissDirection.none,
      action: action,
      content:
          content ??
          Text(message,
            maxLines: 6,
            style: TextStyle(
              letterSpacing: .7,
              color: Colors.white,
              // fontFamily: AppStringsConstants.fontFamily,
            ),
          ),
      backgroundColor: backgroundColor,
      behavior: behavior ?? SnackBarBehavior.floating,
    ),
  );
}

Future<File?> uint8ListToTempFile(Uint8List? uint8List, String fileName) async {
  if (uint8List == null || uint8List.isEmpty) {
    return null;
  }
  try {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = "${tempDir.path}/$fileName";
    File file = File(tempPath);
    await file.writeAsBytes(uint8List);
    return file;
  } catch (e) {
    return null;
  }
}

void vibrateDevice([HapticsType? vibrateType]) async {
  switch (vibrateType) {
    case HapticsType.light:
      HapticFeedback.lightImpact();
      break;
    case HapticsType.medium:
      HapticFeedback.mediumImpact();
      break;
    case HapticsType.heavy:
      HapticFeedback.heavyImpact();
      break;
    case HapticsType.vibrate:
      HapticFeedback.vibrate();
      break;
    case HapticsType.selection:
      HapticFeedback.selectionClick();
      break;
    default:
      HapticFeedback.selectionClick();
      break;
  }
}

enum HapticsType { light, medium, heavy, vibrate, selection }

bool navigateNewScreen(
  BuildContext context,
  String route, {
  Function(Object?)? onValue,
  dynamic extra,
}) {
  if (getLastAppRoute() != route) {
    context.push(route, extra: extra).then(onValue ?? (value) {});
  }
  return true;
}

bool isUpdateAvailable(String currentVersion, String latestVersion) {
  List<int> current = currentVersion.split('.').map(int.parse).toList();
  List<int> latest = latestVersion.split('.').map(int.parse).toList();

  for (int i = 0; i < latest.length; i++) {
    if (i >= current.length || current[i] < latest[i]) {
      return true;
    } else if (current[i] > latest[i]) {
      return false;
    }
  }
  return false;
}

// void launchStoreUrl() async {
//   final url =
//       Platform.isIOS
//           ? AppStringsConstants.appStoreUrl
//           : AppStringsConstants.playStoreUrl;
//   final uri = Uri.parse(url);
//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   }
// }

double convertToAmount(dynamic value) {
  try {
    double parsed;

    if (value is int) {
      parsed = value.toDouble();
    } else if (value is double) {
      parsed = value;
    } else if (value is String) {
      parsed = double.tryParse(value) ?? 0.0;
    } else {
      throw ArgumentError('Unsupported type: ${value.runtimeType}');
    }

    return double.parse(parsed.toStringAsFixed(2));
  } catch (e) {
    throw ArgumentError('Unsupported type: ${value.runtimeType}');
  }
}