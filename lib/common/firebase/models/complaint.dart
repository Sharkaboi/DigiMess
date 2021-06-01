import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Complaint extends Equatable {
  final String complaintId;
  final String complaint;
  final List<String> categories;
  final DocumentReference user;
  final DateTime date;

  Complaint(
      {@required this.complaintId,
      @required this.complaint,
      @required this.user,
      @required this.date,
      @required this.categories});

  factory Complaint.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    if (documentData == null) {
      return null;
    }
    return Complaint(
        complaintId: documentSnapshot.id,
        user: documentData['userId'],
        date: getDateTimeOrNull(documentData['date']),
        categories: List.from(documentData['category']),
        complaint: documentData['complaint']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.user,
      'date': Timestamp.fromDate(this.date),
      'complaint': this.complaint,
      'category': this.categories
    };
  }

  @override
  List<Object> get props =>
      [this.complaintId, this.complaint, this.user, this.date, this.categories];
}
