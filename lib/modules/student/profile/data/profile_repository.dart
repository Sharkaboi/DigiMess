import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfileRepository {
  final CollectionReference _usersClient;

  StudentProfileRepository(this._usersClient);

  Future<DMTaskState> getUserDetails() async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      return await _usersClient.doc("QXe986cVzOQUgQgC2ETo").get().then((value) {
        print(value.data());
        if (!value.exists || value.data() == null) {
          return DMTaskState(
              isTaskSuccess: false,
              taskResultData: null,
              error: DMError(message: "User details not found!"));
        }
        final User userDetails = User.fromDocument(value);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: userDetails, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
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
          error: DMError(message: e.toString()));
    }
  }

  Future<DMTaskState> closeAccount() async {}
}
