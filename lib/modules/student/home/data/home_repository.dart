import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentHomeRepository {
  final CollectionReference _menuClient;
  final CollectionReference _noticesClient;
  final CollectionReference _paymentsClient;

  StudentHomeRepository(this._menuClient, this._noticesClient, this._paymentsClient);

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
        return DMTaskState(
            isTaskSuccess: true, taskResultData: todaysFood, error: null);
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

  Future<DMTaskState> getLatestNotice() async {
    try {
      return await _noticesClient
          .orderBy('date', descending: true)
          .limit(1)
          .get()
          .then((value) {
        final latestNotice =
            value.docs.map((e) => Notice.fromDocument(e)).toList();
        print(latestNotice);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: latestNotice, error: null);
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

  Future<DMTaskState> getPaymentStatus() async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      return await _paymentsClient
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(1)
          .get()
          .then((value) {
        final today = DateTime.now();
        final Payment latestPayment =
            value.docs.isEmpty ? null : Payment.fromDocument(value.docs.first);
        print(latestPayment);
        return DMTaskState(
            isTaskSuccess: true,
            taskResultData: latestPayment != null &&
                latestPayment.paymentDate.month == today.month,
            error: null);
      }).onError((error, stackTrace) {
        print(stackTrace);
        print(error);
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
