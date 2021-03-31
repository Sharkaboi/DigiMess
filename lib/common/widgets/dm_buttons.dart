import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';

class DarkButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Function() onPressed;

  const DarkButton({Key key, this.text, this.onPressed, this.textStyle = DMTypo.bold24WhiteTextStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle,
      ),
      color: DMColors.darkBlue,
      textColor: DMColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
