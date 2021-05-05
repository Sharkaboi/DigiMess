import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_student_count.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_students_present.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffHomeRepository {
  final CollectionReference _menuClient;
  final CollectionReference _noticesClient;
  final CollectionReference _usersClient;
  final CollectionReference _absenteesClient;

  StaffHomeRepository(
      this._menuClient, this._noticesClient, this._absenteesClient, this._usersClient);

  Future<DMTaskState> getTodaysMenu() async {
    try {
      final today = DateTime.now();
      final String dayKey = today.getDayKey();
      return await _menuClient
          .where("isEnabled", isEqualTo: true)
          .where("daysAvailable.$dayKey", isEqualTo: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<MenuItem> todaysFood =
            data.map((e) => MenuItem.fromQueryDocumentSnapshot(e)).toList();
        print(todaysFood);
        return DMTaskState(isTaskSuccess: true, taskResultData: todaysFood, error: null);
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

  Future<DMTaskState> getLatestNotice() async {
    try {
      return await _noticesClient.orderBy('date', descending: true).limit(1).get().then((value) {
        final latestNotice = value.docs.map((e) => Notice.fromDocument(e)).toList();
        print(latestNotice);
        return DMTaskState(isTaskSuccess: true, taskResultData: latestNotice, error: null);
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

  Future<DMTaskState> getEnrolledCount() async {
    try {
      return await _usersClient
          .where("type", isEqualTo: UserType.STUDENT.toStringValue())
          .where("isEnrolled", isEqualTo: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<User> enrolledStudents = data.map((e) => User.fromDocument(e)).toList();
        print(enrolledStudents);
        final int totalCount = enrolledStudents.length;
        final int vegCount = enrolledStudents.where((element) => element.isVeg).length;
        final int nonVegCount = totalCount - vegCount;
        return DMTaskState(
            isTaskSuccess: true,
            taskResultData: StudentEnrolledCount(
                studentsEnrolled: totalCount,
                studentsEnrolledNonVeg: nonVegCount,
                studentsEnrolledVeg: vegCount),
            error: null);
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

  Future<DMTaskState> getPresentCount(StudentEnrolledCount enrolledCount) async {
    try {
      final now = DateTime.now();
      final today = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
      return await _absenteesClient
          .where("startDate", isLessThanOrEqualTo: today)
          .get()
          .then((value) {
        final data = value.docs;
        final List<LeaveEntry> leavesToday = data
            .map((e) => LeaveEntry.fromDocument(e))
            .where((element) => element.endDate.compareTo(today.toDate()) >= 0)
            .toList();
        print(leavesToday);
        final int totalCount = enrolledCount.studentsEnrolled - leavesToday.length;
        int vegCount = enrolledCount.studentsEnrolledVeg;
        int nonVegCount = enrolledCount.studentsEnrolledNonVeg;
        leavesToday.forEach((element) {
          element.user.get().then((value) {
            final user = User.fromDocument(value);
            if (user != null) {
              user.isVeg ? --vegCount : --nonVegCount;
            }
          });
        });
        return DMTaskState(
            isTaskSuccess: true,
            taskResultData: StudentPresentCount(
                studentsPresent: totalCount,
                studentsPresentNonVeg: nonVegCount,
                studentsPresentVeg: vegCount),
            error: null);
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
