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
    sharedPrefs.setString(SharedPrefKeys.USER_TYPE, userType.toStringValue());
  }

  static Future<String> getTheUserId() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final String userType = sharedPrefs.getString(SharedPrefKeys.USER_ID);
    return userType;
  }

  static setTheUserId(String userId) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(SharedPrefKeys.USER_ID, userId);
  }

  static Future<String> getUsername() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(SharedPrefKeys.USERNAME);
  }
}
