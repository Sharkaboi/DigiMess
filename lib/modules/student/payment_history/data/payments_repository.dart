import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentPaymentsRepository {
  final CollectionReference _paymentsClient;

  StudentPaymentsRepository(this._paymentsClient);

  Future<DMTaskState> getAllPayments() async {
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
          .get()
          .then((value) {
        final data = value.docs;
        final List<Payment> paymentsList =
            data.map((e) => Payment.fromDocument(e)).toList();
        print(paymentsList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: paymentsList, error: null);
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
