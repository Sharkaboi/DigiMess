import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/payment_status.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentHomeRepository {
  final CollectionReference _menuClient;
  final CollectionReference _noticesClient;
  final CollectionReference _paymentsClient;
  final CollectionReference _absenteesClient;

  StudentHomeRepository(this._menuClient, this._noticesClient,
      this._paymentsClient, this._absenteesClient);

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
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      return await _paymentsClient
          .where('userId', isEqualTo: user)
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
            taskResultData: PaymentStatus(
                hasPaidFees: latestPayment != null &&
                    latestPayment.paymentDate.isSameMonthAs(today),
                lastPaymentDate: latestPayment.paymentDate),
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

  Future<DMTaskState> makePayment(Payment payment) async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      final Payment paymentWithUserRef = payment.copyWith(user: user);
      return await _paymentsClient
          .add(paymentWithUserRef.toMap())
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

  Future<DMTaskState> getLeaveCount(PaymentStatus paymentStatus) async {
    try {
      final String userId = await SharedPrefRepository.getTheUserId();
      if (userId == null) {
        return DMTaskState(
            isTaskSuccess: false,
            taskResultData: null,
            error: DMError(message: "Login expired, Log in again."));
      }
      final DocumentReference user =
          FirebaseClient.getUsersCollectionReference().doc(userId);
      DateTime lastDayOfDueMonth;
      DateTime firstDayOfDueMonth;
      if (paymentStatus.lastPaymentDate == null) {
        final DateTime today = DateTime.now();
        lastDayOfDueMonth = DateTime(today.year, today.month, 0);
        firstDayOfDueMonth = DateTime(today.year, today.month - 1);
      } else {
        lastDayOfDueMonth = DateTime(paymentStatus.lastPaymentDate.year,
            paymentStatus.lastPaymentDate.month + 1, 0);
        firstDayOfDueMonth = DateTime(paymentStatus.lastPaymentDate.year,
            paymentStatus.lastPaymentDate.month);
      }
      return await _absenteesClient
          .where('userId', isEqualTo: user)
          .where('startDate', isLessThanOrEqualTo: lastDayOfDueMonth)
          .where('startDate', isGreaterThanOrEqualTo: firstDayOfDueMonth)
          .get()
          .then((value) {
        final data = value.docs;
        final List<LeaveEntry> leavesList =
            data.map((e) => LeaveEntry.fromDocument(e)).toList();
        int leaveCount = 0;
        leavesList.forEach((element) {
          for (DateTime day = element.startDate;
              day.compareTo(element.endDate) <= 0;
              day = day.copyWith(day: day.day + 1)) {
            if (day.month != lastDayOfDueMonth.month) break;
            leaveCount++;
          }
        });
        print(leaveCount);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: leaveCount, error: null);
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
