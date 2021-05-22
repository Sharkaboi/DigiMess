import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/leaves/data/util/leaves_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffLeavesRepository {
  final CollectionReference _leavesRepository;

  StaffLeavesRepository(this._leavesRepository);

  Future<DMTaskState> getAllLeaves() async {
    try {
      return await _leavesRepository
          .orderBy('applyDate', descending: true)
          .get()
          .then((value) async {
        final data = value.docs;
        final List<LeaveEntry> leavesList = data.map((e) => LeaveEntry.fromDocument(e)).toList();
        final List<LeavesWrapper> listOfLeavesWithUser = [];
        await Future.forEach(leavesList, (element) async {
          await element.user.get().then((value) =>
              listOfLeavesWithUser.add(LeavesWrapper(element, User.fromDocument(value))));
        });
        print(listOfLeavesWithUser);
        return DMTaskState(isTaskSuccess: true, taskResultData: listOfLeavesWithUser, error: null);
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
