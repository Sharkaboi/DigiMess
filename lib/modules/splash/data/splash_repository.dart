import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/app_status.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';

class SplashRepository {
  Future<DMTaskState> initApp() async {
    try {
      await Firebase.initializeApp();
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      final AppStatus appStatus =
          await SharedPrefRepository.getAppClientStatus();
      final CollectionReference _usersClient =
          FirebaseClient.getUsersCollectionReference();
      if (appStatus.userId == null) {
        return DMTaskState(
            isTaskSuccess: true, taskResultData: appStatus, error: null);
      }
      return await _usersClient.doc(appStatus.userId ?? "").get().then((value) {
        final User user = User.fromDocument(value);
        print(user);
        final AppStatus status =
            appStatus.copyWith(isEnabledInFirebase: user.isEnrolled ?? false);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: status, error: null);
      }).onError((error, stackTrace) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          error: DMError(message: e.toString(), throwable: e));
    }
  }
}
