import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:flutter/material.dart';

class DMStyles {
  DMStyles._();

  static const TextStyle headerStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle normalTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle smallerTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const TextStyle smallerBlueTextStyle = TextStyle(
      fontSize: 14, color: DMColors.darkBlue, fontWeight: FontWeight.bold);
}
