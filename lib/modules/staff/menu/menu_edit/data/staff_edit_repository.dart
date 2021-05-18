import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffMenuEditRepository {
  final CollectionReference _menuClient;

  StaffMenuEditRepository(this._menuClient);

  Future<DMTaskState> changeEnabledStatus(bool isEnabled, String id) async {
    try {
      return await _menuClient
          .doc(id)
          .update({'isEnabled': isEnabled}).then((value) {
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

  Future<DMTaskState> setAvailableDay(String id, DaysAvailable days) async {
    try {
      return await _menuClient
          .doc(id)
          .update({'daysAvailable': days.toMap()}).then((value) {
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

  Future<DMTaskState> setAvailableTime(
      String id, MenuItemIsAvailable time) async {
    try {
      return await _menuClient
          .doc(id)
          .update({'isAvailable': time.toMap()}).then((value) {
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
