import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintsRepository {
  final CollectionReference _complaints;

  ComplaintsRepository(this._complaints);

  Future<DMTaskState> getAllComplaints() async {
    try {
      return await _complaints
          .orderBy('date', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<Complaint> complaintsList =
        data.map((e) => Complaint.fromDocument(e)).toList();
        print(complaintsList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: complaintsList, error: null);
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
}