import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';

class DarkButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Function() onDisabledPressed;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;

  const DarkButton(
      {Key key,
      this.text,
      this.onPressed,
      this.textStyle = DMTypo.bold24WhiteTextStyle,
      this.padding,
      this.isEnabled = true,
      this.onDisabledPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isEnabled
        ? FlatButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onPressed ?? () {},
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              text,
              style: textStyle,
            ),
            color: DMColors.darkBlue,
            textColor: DMColors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )
        : FlatButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onDisabledPressed ?? () {},
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              text,
              style: textStyle,
            ),
            color: DMColors.grey,
            textColor: DMColors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          );
  }
}
