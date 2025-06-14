import 'package:flutter/material.dart';

class AppMessenger {
  static void scaffoldMessenger({
    required String message,
    TextStyle? messageStyle,
    required BuildContext context,
    Duration? duration,
    EdgeInsets? margin,
    SnackBarAction? action,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    ShapeBorder? shape,
    DismissDirection dismissDirection = DismissDirection.down,
    Color? bgColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: messageStyle),
        action: action,
        shape: shape,
        behavior: behavior,
        dismissDirection: dismissDirection,
        duration: duration ?? const Duration(seconds: 3),
        margin: margin,
        backgroundColor: bgColor ?? Colors.grey.shade300,
      ),
    );
  }
}
