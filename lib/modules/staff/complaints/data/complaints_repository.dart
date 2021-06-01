import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/complaints/data/util/complaint_wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffComplaintsRepository {
  final CollectionReference _complaintsClient;

  StaffComplaintsRepository(this._complaintsClient);

  Future<DMTaskState> getAllComplaints() async {
    try {
      return await _complaintsClient.orderBy('date', descending: true).get().then((value) async {
        final List<ComplaintWrapper> listOfComplaintsWithUser = [];
        final data = value.docs;
        final List<Complaint> complaintsList = data.map((e) => Complaint.fromDocument(e)).toList();
        print(complaintsList);
        await Future.forEach(complaintsList, (element) async {
          await element.user.get().then((value) =>
              listOfComplaintsWithUser.add(ComplaintWrapper(element, User.fromDocument(value))));
        });
        return DMTaskState(
            isTaskSuccess: true, taskResultData: listOfComplaintsWithUser, error: null);
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
