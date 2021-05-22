import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDetailsRepository {
  final CollectionReference _usersClient;

  StudentDetailsRepository(this._usersClient);

  Future<DMTaskState> toggleUserStatus(String userId, bool isDisabled) async {
    try {
      return await _usersClient.doc(userId).update({'isEnrolled': isDisabled}).then((_) {
        return DMTaskState(isTaskSuccess: true, taskResultData: null, error: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false, taskResultData: null, error: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false, taskResultData: null, error: DMError(message: e.toString()));
    }
  }
}
