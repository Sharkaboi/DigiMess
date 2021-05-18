import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class DMColorPillButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Function() onDisabledPressed;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;
  final Color color;

  const DMColorPillButton(
      {Key key,
      this.text,
      this.onPressed,
      this.textStyle = DMTypo.bold16WhiteTextStyle,
      this.padding,
      this.isEnabled = true,
      this.color,
      this.onDisabledPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (isEnabled ? onPressed : onDisabledPressed) ?? () {},
      child: Text(text, style: textStyle, textAlign: TextAlign.center),
      style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          backgroundColor: MaterialStateProperty.all(color),
          overlayColor: MaterialStateProperty.all(isEnabled
              ? DMColors.accentBlue.withOpacity(0.3)
              : DMColors.white.withOpacity(0.3)),
          padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )),
    );
  }
}
