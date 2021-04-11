import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LeaveEntry extends Equatable {
  final String leaveEntryId;
  final DocumentReference user;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime applyDate;

  LeaveEntry(
      {@required this.leaveEntryId,
      @required this.user,
      @required this.startDate,
      @required this.endDate,
      @required this.applyDate});

  factory LeaveEntry.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    return LeaveEntry(
        leaveEntryId: documentSnapshot.id,
        user: documentData['userId'],
        startDate: getDateTimeOrNull(documentData['startDate']),
        endDate: getDateTimeOrNull(documentData['endDate']),
        applyDate: getDateTimeOrNull(documentData['applyDate']));
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.user,
      'startDate': Timestamp.fromDate(this.startDate),
      'endDate': Timestamp.fromDate(this.endDate),
      'applyDate': Timestamp.fromDate(this.applyDate)
    };
  }

  @override
  List<Object> get props => [
        this.leaveEntryId,
        this.startDate,
        this.user,
        this.endDate,
        this.applyDate
      ];
}
