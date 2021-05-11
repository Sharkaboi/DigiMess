import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffAnnualPollRepository {
  final CollectionReference _menuClient;

  StaffAnnualPollRepository(this._menuClient);

  Future<DMTaskState> getMenuItems() async {
    try {
      return await _menuClient.get().then((value) {
        final data = value.docs;
        final List<MenuItem> menuList =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(menuList);
        return DMTaskState(isTaskSuccess: true, taskResultData: menuList, error: null);
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

  Future<DMTaskState> resetAnnualPoll() async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      return await _menuClient.get().then((value) async {
        value.docs.forEach((element) {
          batch.update(element.reference, {
            "annualPoll.forBreakFast": 0,
            "annualPoll.forLunch": 0,
            "annualPoll.forDinner": 0,
          });
        });
        batch.commit();
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
