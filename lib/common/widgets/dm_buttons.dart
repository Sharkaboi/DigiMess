import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class DMPillButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Function() onDisabledPressed;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;

  const DMPillButton(
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
    return TextButton(
      onPressed: (isEnabled ? onPressed : onDisabledPressed) ?? () {},
      child: Text(text, style: textStyle, textAlign: TextAlign.center),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              isEnabled ? DMColors.darkBlue : DMColors.grey),
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

class DMRoundedPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final int elevation;

  const DMRoundedPrimaryButton(
      {Key key,
      this.onPressed,
      this.text,
      this.textStyle,
      this.padding,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () {},
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(DMColors.primaryBlue),
          foregroundColor: MaterialStateProperty.all(DMColors.white),
          elevation: MaterialStateProperty.all(elevation ?? 4),
          overlayColor:
              MaterialStateProperty.all(DMColors.white.withOpacity(0.3)),
          padding: MaterialStateProperty.all(
              padding ?? EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(text,
          style: textStyle ?? DMTypo.bold16WhiteTextStyle,
          textAlign: TextAlign.center),
    );
  }
}

class DMRoundedWhiteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final int elevation;

  const DMRoundedWhiteButton(
      {Key key,
      this.onPressed,
      this.text,
      this.textStyle,
      this.padding,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () {},
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(DMColors.white),
          foregroundColor: MaterialStateProperty.all(DMColors.black),
          elevation: MaterialStateProperty.all(elevation ?? 4),
          padding: MaterialStateProperty.all(
              padding ?? EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(text,
          style: textStyle ?? DMTypo.bold16BlackTextStyle,
          textAlign: TextAlign.center),
    );
  }
}
