import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Notice extends Equatable {
  final String noticeId;
  final String title;
  final DateTime date;

  Notice({@required this.noticeId, @required this.title, @required this.date});

  factory Notice.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    if (documentData == null) {
      return null;
    }
    return Notice(
        noticeId: documentSnapshot.id,
        title: documentData['title'],
        date: getDateTimeOrNull(documentData['date']));
  }

  Map<String, dynamic> toMap() {
    return {'title': this.title, 'date': Timestamp.fromDate(this.date)};
  }

  @override
  List<Object> get props => [this.noticeId, this.title, this.date];
}
