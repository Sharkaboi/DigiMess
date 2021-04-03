import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentComplaintsRepository {
  final CollectionReference _complaintsClient;

  StudentComplaintsRepository(this._complaintsClient);

  Future<DMTaskState> placeComplaint(
      List<String> categories, String complaint) async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      return await _complaintsClient
          .add(Complaint(
                  complaint: complaint,
                  categories: categories,
                  date: DateTime.now(),
                  userId: userId,
                  complaintId: '')
              .toMap())
          .then((value) {
        return DMTaskState(
            isTaskSuccess: true, taskResultData: null, error: null);
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
