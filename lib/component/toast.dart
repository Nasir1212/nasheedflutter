import 'package:flutter/material.dart';
import 'package:naate/main.dart';

class Toast {
  static void _show(String message, Color bgColor) {
    scaffoldMessengerKey.currentState
        ?.hideCurrentSnackBar(); // Hide old SnackBar

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 350,
        backgroundColor: bgColor,
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        duration: Duration(seconds: 2), // Auto dismiss after 2 seconds
      ),
    );
  }

  static void error(String message) {
    _show(message, Colors.red);
  }

  static void success(String message) {
    _show(message, Colors.green);
  }
}
