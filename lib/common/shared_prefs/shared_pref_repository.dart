import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_keys.dart';
import 'package:DigiMess/common/util/app_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepository {
  SharedPrefRepository._();

  static Future<UserType> getUserType() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final String userType = sharedPrefs.getString(SharedPrefKeys.USER_TYPE);
    return UserTypeExtensions.fromString(userType);
  }

  static Future<void> setUserType(UserType userType) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
        SharedPrefKeys.USER_TYPE, userType.toStringValue());
  }

  static Future<String> getTheUserId() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(SharedPrefKeys.USER_ID);
  }

  static Future<void> setTheUserId(String userId) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(SharedPrefKeys.USER_ID, userId);
  }

  static Future<void> setUsername(String username) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(SharedPrefKeys.USERNAME, username);
  }

  static Future<String> getUsername() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(SharedPrefKeys.USERNAME);
  }

  static Future<AppStatus> getAppClientStatus() async {
    final UserType userType = await getUserType();
    final String userId = await getTheUserId();
    final String username = await getUsername();
    return AppStatus(userType: userType, userId: userId, username: username);
  }

  static Future<void> logOutUser() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
  }

  static Future<void> setLastPollYear(DateTime date) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
        SharedPrefKeys.LAST_POLL_TAKEN_YEAR, date.toIso8601String());
  }

  static Future<DateTime> getLastPollYear() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    // set epoch as default
    final DateTime defaultDate = DateTime.fromMillisecondsSinceEpoch(0);
    final String lastVotedDate =
        sharedPrefs.getString(SharedPrefKeys.LAST_POLL_TAKEN_YEAR);
    if (lastVotedDate == null || lastVotedDate.trim().isEmpty)
      return defaultDate;
    else {
      final DateTime dateTime = DateTime.tryParse(lastVotedDate);
      if (dateTime == null)
        return defaultDate;
      else
        return dateTime;
    }
  }
}
