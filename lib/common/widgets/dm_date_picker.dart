import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:flutter/material.dart';

class DMDatePicker {
  DMDatePicker._();

  static Future<DateTime> showPicker(BuildContext context,
      {DateTime initialDate, DateTime firstDate, DateTime lastDate}) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.fromMicrosecondsSinceEpoch(0),
      lastDate: lastDate ?? DateTime.now().add(Duration(days: 60)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: DMColors.primaryBlue,
              onPrimary: DMColors.white,
              surface: DMColors.primaryBlue,
              onSurface: DMColors.black,
            ),
            dialogBackgroundColor: DMColors.white,
          ),
          child: child,
        );
      },
    );
  }
}
