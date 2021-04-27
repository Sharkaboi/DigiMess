import 'package:DigiMess/common/firebase/firebase_client.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/shared_prefs/shared_pref_repository.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/common/util/task_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentLeavesRepository {
  final CollectionReference _absenteesClient;

  StudentLeavesRepository(this._absenteesClient);

  Future<DMTaskState> getAllLeaves() async {
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
      return await _absenteesClient
          .where('userId', isEqualTo: user)
          .orderBy('applyDate', descending: true)
          .get()
          .then((value) {
        final data = value.docs;
        final List<LeaveEntry> leavesList =
            data.map((e) => LeaveEntry.fromDocument(e)).toList();
        print(leavesList);
        return DMTaskState(
            isTaskSuccess: true, taskResultData: leavesList, error: null);
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

  Future<DMTaskState> applyForLeave(DateTimeRange leaveInterval) async {
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
      return await _absenteesClient
          .add(LeaveEntry(
                  startDate: leaveInterval.start,
                  endDate: leaveInterval.end,
                  applyDate: DateTime.now(),
                  user: user,
                  leaveEntryId: '')
              .toMap())
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
}
