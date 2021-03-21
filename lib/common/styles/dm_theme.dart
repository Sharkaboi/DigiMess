import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';

class DMTheme {
  DMTheme._();

  static const FONT_NAME = "Comfortaa";

  static ThemeData themeData({bool isDarkTheme = false, BuildContext context}) {
    final base = isDarkTheme ? ThemeData.dark() : ThemeData.light();

    return ThemeData(
        fontFamily: FONT_NAME,
        primaryColor: DMColors.primaryBlue,
        accentColor: DMColors.accentBlue,
        cursorColor: DMColors.primaryBlue,
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: DMColors.primaryBlue,
            selectionHandleColor: DMColors.primaryBlue,
            selectionColor: DMColors.primaryBlue.withOpacity(0.3)),
        backgroundColor: isDarkTheme ? DMColors.black : DMColors.white,
        indicatorColor: DMColors.primaryBlue.withOpacity(0.3),
        buttonColor: DMColors.primaryBlue,
        hintColor: DMColors.grey.withOpacity(0.3),
        highlightColor: DMColors.primaryBlue.withOpacity(0.3),
        hoverColor: DMColors.primaryBlue.withOpacity(0.3),
        focusColor: DMColors.primaryBlue.withOpacity(0.3),
        disabledColor: DMColors.grey,
        textTheme: base.textTheme.copyWith(
          subtitle2: base.textTheme.subtitle2.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          overline: base.textTheme.overline.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline6: base.textTheme.headline6.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline5: base.textTheme.headline5.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline4: base.textTheme.headline4.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline3: base.textTheme.headline3.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline2: base.textTheme.headline2.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          headline1: base.textTheme.headline1.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          subtitle1: base.textTheme.subtitle1.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          caption: base.textTheme.caption.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          bodyText1: base.textTheme.bodyText1.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          bodyText2: base.textTheme.bodyText2.copyWith(
              fontFamily: FONT_NAME,
              color: isDarkTheme ? DMColors.white : DMColors.black),
          button: TextStyle(fontFamily: FONT_NAME),
        ),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(DMColors.primaryBlue),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
                overlayColor: MaterialStateProperty.all(
                    DMColors.primaryBlue.withOpacity(0.3)),
                foregroundColor: MaterialStateProperty.all(DMColors.white))),
        dividerColor: DMColors.mutedBlue,
        cardColor: isDarkTheme ? DMColors.black : DMColors.white,
        canvasColor: isDarkTheme ? DMColors.black : DMColors.white,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          brightness: Brightness.dark,
          titleTextStyle: DMTypo.bold16WhiteTextStyle,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: DMColors.grey, fontFamily: FONT_NAME),
        ),
        buttonTheme: ButtonThemeData(
            buttonColor: DMColors.primaryBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            textTheme: ButtonTextTheme.primary));
  }
}
