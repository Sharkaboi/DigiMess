import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffNoticesRepository {
  final CollectionReference _noticesClient;

  StaffNoticesRepository(this._noticesClient);

  Future<DMTaskState> getAllNotices() async {
    try {
      return await _noticesClient.orderBy('date', descending: true).get().then((value) async {
        final data = value.docs;
        final List<Notice> noticesList = data.map((e) => Notice.fromDocument(e)).toList();
        print(noticesList);
        return DMTaskState(isTaskSuccess: true, taskResultData: noticesList, error: null);
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

  Future<DMTaskState> placeNotice(String title) async {
    try {
      return await _noticesClient
          .add(Notice(title: title, date: DateTime.now(), noticeId: "").toMap())
          .then((value) {
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
