import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:flutter/material.dart';

class DarkButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const DarkButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      color: DMColors.primaryBlue,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
