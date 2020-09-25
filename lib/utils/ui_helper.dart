import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart'; // require flushbar package

class UIHelper {
  static void _buildFlushbar(BuildContext context,
      {String message, IconData icon, Color color}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      message: message ?? '',
      icon: Icon(
        icon ?? Icons.done,
        size: 28.0,
        color: color ?? Colors.green[300],
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: color ?? Colors.green[300],
    )..show(context);
  }

  static void showSuccessFlushbar(BuildContext context, String message) {
    _buildFlushbar(context, message: message);
  }
}
