import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/menu/data/staff-menu-screen-data/util/staff_menu_filter_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffMenuRepository {
  final CollectionReference _menuClient;

  StaffMenuRepository(this._menuClient);

  Future<DMTaskState> getMenuItems(
      {MenuFilterType menuFilterType = MenuFilterType.BOTH}) async {
    try {
      Query query;
      if (menuFilterType == MenuFilterType.BOTH) {
        query = _menuClient.where("isEnabled", isEqualTo: true);
      } else {
        query = _menuClient
            .where("isVeg", isEqualTo: menuFilterType == MenuFilterType.VEG);
      }
      return await query.get().then((value) {
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
}