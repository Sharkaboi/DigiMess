import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessCardRepository {
  final CollectionReference _paymentsClient;

  MessCardRepository(this._paymentsClient);

  Future<DMTaskState> getMessCardStatus() async {
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
          .then((value) async {
        final today = DateTime.now();
        final Payment latestPayment =
            value.docs.isEmpty ? null : Payment.fromDocument(value.docs.first);
        print(latestPayment);
        return await user.get().then((value) {
          print(value.data());
          if (!value.exists || value.data() == null) {
            return DMTaskState(
                isTaskSuccess: false,
                taskResultData: null,
                error: DMError(message: "User details not found!"));
          }
          final User userDetails = User.fromDocument(value);
          return DMTaskState(
              isTaskSuccess: true,
              taskResultData: latestPayment != null &&
                  userDetails.isEnrolled &&
                  ((latestPayment.paymentDate.isSameMonthAs(today)) ||
                      (latestPayment.paymentDate.isLastMonthOf(today) &&
                          DateExtensions.isBeforeDueDate())),
              error: null);
        }).onError((error, stackTrace) {
          print(stackTrace);
          print(error);
          return DMTaskState(
              isTaskSuccess: false,
              taskResultData: null,
              error: DMError(message: error.toString()));
        });
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
