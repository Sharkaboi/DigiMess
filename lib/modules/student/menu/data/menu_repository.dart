import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/student/menu/data/util/menu_filter_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuRepository {
  final CollectionReference _menuClient;

  MenuRepository(this._menuClient);

  Future<DMTaskState> getMenuItems(
      {String searchQuery = "",
      MenuFilterType menuFilterType = MenuFilterType.BOTH}) async {
    try {
      Query query;
      if (menuFilterType == MenuFilterType.BOTH) {
        query = _menuClient
            .where("isEnabled", isEqualTo: true)
            .where("name", isGreaterThanOrEqualTo: searchQuery)
            .where("name", isLessThan: searchQuery + 'z');
      } else {
        query = _menuClient
            .where("isEnabled", isEqualTo: true)
            .where("isVeg", isEqualTo: menuFilterType == MenuFilterType.VEG)
            .where("name", isGreaterThanOrEqualTo: searchQuery)
            .where("name", isLessThan: searchQuery + 'z');
      }
      return await query.get().then((value) {
        final data = value.docs;
        final List<MenuItem> menuList =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(menuList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: menuList, errors: null);
      }).onError((error, stackTrace) {
        print(stackTrace.toString());
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            errors: DMError(message: error.toString()));
      });
    } catch (e) {
      print(e);
      return DMTaskState(
          isTaskSuccess: false,
          taskResultData: null,
          errors: DMError(message: e.toString()));
    }
  }
}
