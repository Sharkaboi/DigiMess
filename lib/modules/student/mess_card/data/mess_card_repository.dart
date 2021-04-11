import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
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
          .then((value) {
        final today = DateTime.now();
        final Payment latestPayment =
            value.docs.isEmpty ? null : Payment.fromDocument(value.docs.first);
        print(latestPayment);
        return DMTaskState(
            isTaskSuccess: true,
            taskResultData: latestPayment != null &&
                ((latestPayment.paymentDate.month == today.month &&
                        latestPayment.paymentDate.year == today.year) ||
                    (latestPayment.paymentDate.year == today.year &&
                        latestPayment.paymentDate.month == today.month - 1 &&
                        today.day < 8)),
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
