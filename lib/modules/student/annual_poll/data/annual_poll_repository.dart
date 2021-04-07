import 'package:DigiMess/common/constants/vote_entry.dart';
import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAnnualPollRepository {
  final CollectionReference _menuClient;

  StudentAnnualPollRepository(this._menuClient);

  Future<DMTaskState> getAllMenuItems() async {
    try {
      return await _menuClient.get().then((value) {
        final data = value.docs;
        final List<MenuItem> menuList =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(menuList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: menuList, error: null);
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

  Future<DMTaskState> placeVotes(List<VoteEntry> listOfVotes) async {
    //todo: add shared pref
  }
}
