import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  // true => dark, false => light
  static const THEME_OPTION = "THEME_OPTION";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_OPTION, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_OPTION) ?? false;
  }
}