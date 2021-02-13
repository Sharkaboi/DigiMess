import 'package:flutter/material.dart';

class DMSnackBar {
  static void show(BuildContext context, String message,
      {SnackBarAction action}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: action,
    ));
    return;
  }
}
