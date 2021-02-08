import 'package:DigiMess/common/styles/colors.dart';
import 'package:flutter/material.dart';

class Styles {
  static const FONT_NAME = "Comfortaa";

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    final base = isDarkTheme ? ThemeData.dark() : ThemeData.light();

    return ThemeData(
      fontFamily: FONT_NAME,
      primaryColor: DMColors.primaryBlue,
      accentColor: DMColors.accentBlue,
      cursorColor: DMColors.primaryBlue,
      backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: DMColors.grey,
      textTheme: base.textTheme.copyWith(
        headline1: base.textTheme.headline1.copyWith(
            fontFamily: FONT_NAME,
            color: isDarkTheme ? Colors.white : Colors.black),
        subtitle1: base.textTheme.subtitle1.copyWith(
            fontFamily: FONT_NAME,
            color: isDarkTheme ? Colors.white : Colors.black),
        caption: base.textTheme.caption.copyWith(
            fontFamily: FONT_NAME,
            color: isDarkTheme ? Colors.white : Colors.black),
        bodyText1: base.textTheme.bodyText1.copyWith(
            fontFamily: FONT_NAME,
            color: isDarkTheme ? Colors.white : Colors.black),
        bodyText2: base.textTheme.bodyText2.copyWith(
            fontFamily: FONT_NAME,
            color: isDarkTheme ? Colors.white : Colors.black),
        button: TextStyle(
            fontFamily: FONT_NAME),
      ),
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: DMColors.grey),
      ),
    );
  }
}
