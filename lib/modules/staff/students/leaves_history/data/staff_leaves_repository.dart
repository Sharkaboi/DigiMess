import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffStudentLeavesRepository {
  final CollectionReference _leavesRepository;

  StaffStudentLeavesRepository(this._leavesRepository);

  Future<DMTaskState> getAllLeaves(String userId) async {
    try {
      final DocumentReference user = FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _leavesRepository
          .where('userId', isEqualTo: user)
          .orderBy('applyDate', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<LeaveEntry> leavesList = data.map((e) => LeaveEntry.fromDocument(e)).toList();
        print(leavesList);
        return DMTaskState(isTaskSuccess: true, taskResultData: leavesList, error: null);
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
