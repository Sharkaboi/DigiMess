import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Complaint extends Equatable {
  final String complaintId;
  final String complaint;
  final String userId;
  final DateTime date;

  Complaint(
      {@required this.complaintId,
      @required this.complaint,
      @required this.userId,
      @required this.date});

  factory Complaint.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    return Complaint(
        complaintId: documentSnapshot.id,
        userId: documentData['userId'],
        date: getDateTimeOrNull(documentData['date']),
        complaint: documentData['complaint']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'date': Timestamp.fromDate(this.date),
      'complaint': this.complaint
    };
  }

  @override
  List<Object> get props =>
      [this.complaintId, this.complaint, this.userId, this.date];
}