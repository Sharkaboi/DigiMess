import 'package:DigiMess/common/constants/user_types.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepository {
  SharedPrefRepository._();

  static Future<UserType> getUserType() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final String userType = sharedPrefs.getString(SharedPrefKeys.USER_TYPE);
    return UserTypeExtensions.fromString(userType);
  }

  static setUserType(UserType userType) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
        SharedPrefKeys.USER_TYPE, userType.toStringValue());
  }

  static Future<String> getTheUserId() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(SharedPrefKeys.USER_ID);
  }

  static setTheUserId(String userId) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(SharedPrefKeys.USER_ID, userId);
  }

  static setUsername(String username) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(SharedPrefKeys.USERNAME, username);
  }

  static Future<String> getUsername() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(SharedPrefKeys.USERNAME);
  }

  static setLastPollYear(DateTime date) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
        SharedPrefKeys.LAST_POLL_TAKEN_YEAR, date.year.toString());
  }

  static Future<DateTime> getLastPollYear() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    // set epoch as default
    final DateTime defaultDate = DateTime.fromMillisecondsSinceEpoch(0);
    final String lastVotedYear =
        sharedPrefs.getString(SharedPrefKeys.LAST_POLL_TAKEN_YEAR);
    if (lastVotedYear == null || lastVotedYear.trim().isEmpty)
      return defaultDate;
    else {
      final int year = int.tryParse(lastVotedYear);
      if (year == null)
        return defaultDate;
      else
        return DateTime(year);
    }
  }
}
