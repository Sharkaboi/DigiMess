import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffComplaintsRepository {
  final CollectionReference _complaintsClient;

  StaffComplaintsRepository(this._complaintsClient);

  Future<DMTaskState> getAllComplaints(String userId) async {
    try {
      final DocumentReference user = FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _complaintsClient
          .where('userId', isEqualTo: user)
          .orderBy('date', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<Complaint> complaintList = data.map((e) => Complaint.fromDocument(e)).toList();
        print(complaintList);
        return DMTaskState(isTaskSuccess: true, taskResultData: complaintList, error: null);
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
