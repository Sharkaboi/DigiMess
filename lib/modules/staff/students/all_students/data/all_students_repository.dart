import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/students/all_students/data/util/student_filter_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllStudentsRepository {
  final CollectionReference _usersClient;

  AllStudentsRepository(this._usersClient);

  Future<DMTaskState> getAllStudents(
      {StudentFilterType studentFilterType = StudentFilterType.BOTH}) async {
    try {
      Query query;
      if (studentFilterType == StudentFilterType.BOTH) {
        query = _usersClient.where('type', isEqualTo: UserType.STUDENT.toStringValue());
      } else {
        query = _usersClient
            .where('type', isEqualTo: UserType.STUDENT.toStringValue())
            .where("details.isVeg", isEqualTo: studentFilterType == StudentFilterType.VEG);
      }
      return await query.get().then((value) {
        final data = value.docs;
        final List<User> studentsList = data.map((e) => User.fromDocument(e)).toList();
        print(studentsList);
        return DMTaskState(isTaskSuccess: true, taskResultData: studentsList, error: null);
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
