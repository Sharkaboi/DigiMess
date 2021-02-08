import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/common/util/user_types.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashRepository {
  Future<DMTaskState> initApp() async {
    try {
      final FirebaseApp defaultApp = await Firebase.initializeApp();
      final UserType _currentUserType =
          await SharedPrefRepository.getUserType();
      return DMTaskState(
          isTaskSuccess: true, taskResultData: _currentUserType, errors: null);
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          errors: DMError(message: e.toString(), throwable: e));
    }
  }
}
