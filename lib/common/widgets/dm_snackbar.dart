import 'package:flutter/material.dart';

class DMSnackBar {
  DMSnackBar._();

  static void show(BuildContext context, String message,
      {SnackBarAction action}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: action,
    ));
    return;
  }
}
