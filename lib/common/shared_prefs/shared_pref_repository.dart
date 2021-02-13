import 'package:DigiMess/common/shared_prefs/shared_pref_keys.dart';
import 'package:DigiMess/common/util/user_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefRepository {
  static Future<UserType> getUserType() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final String userType = sharedPrefs.getString(SharedPrefKeys.USER_TYPE);
    if (userType == UserType.STUDENT.toStringValue()) {
      return UserType.STUDENT;
    } else if (userType == UserType.COORDINATOR.toStringValue()) {
      return UserType.COORDINATOR;
    } else {
      return UserType.GUEST;
    }
  }

  static setUserType(UserType userType) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(SharedPrefKeys.USER_TYPE, userType.toStringValue());
  }
}
