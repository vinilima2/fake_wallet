import 'package:flutter/material.dart';

enum AlertType {
  SUCCESS,
  WARNING,
  ERROR;
}

class Alert {
  void showMessage(BuildContext context, String message, AlertType type) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: getColor(type),
      duration: const Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Color getColor(AlertType type) {
    Color color;
    switch (type) {
      case AlertType.SUCCESS:
        color = Colors.greenAccent;
        break;
      case AlertType.WARNING:
        color = Colors.yellowAccent;
        break;
      case AlertType.ERROR:
        color = Colors.redAccent;
        break;
      default:
        color = Colors.grey;
        break;
    }
    return color;
  }
}
