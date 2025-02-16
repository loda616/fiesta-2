import 'package:flutter/material.dart';

import 'failures.dart';

class ErrorHandler {
  static String getMessage(dynamic error) {
    if (error is ServerFailure) {
      return error.message;
    }
    if (error is CacheFailure) {
      return 'No cached data available. Please check your internet connection.';
    }
    if (error is NetworkFailure) {
      return 'No internet connection. Please check your network settings.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}