import 'package:DigiMess/common/constants/enums/payment_account_type.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Payment extends Equatable {
  final String paymentId;
  final DocumentReference user;
  final PaymentAccountType paymentAccountType;
  final DateTime paymentDate;
  final int paymentAmount;
  final String description;

  Payment(
      {@required this.paymentId,
      @required this.user,
      @required this.paymentAccountType,
      @required this.paymentDate,
      @required this.paymentAmount,
      @required this.description});

  factory Payment.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    if (documentData == null) {
      return null;
    }
    return Payment(
        paymentId: documentSnapshot.id,
        user: documentData['userId'],
        paymentAccountType: PaymentAccountTypeExtensions.fromString(
            documentData['accountType']),
        paymentDate: getDateTimeOrNull(documentData['date']),
        paymentAmount: documentData['amount'],
        description: documentData['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.user,
      'accountType': this.paymentAccountType.toStringValue(),
      'date': Timestamp.fromDate(this.paymentDate),
      'amount': this.paymentAmount,
      'description': this.description
    };
  }

  @override
  List<Object> get props => [
        this.paymentId,
        this.user,
        this.paymentAccountType,
        this.paymentDate,
        this.paymentAmount,
        this.description
      ];
}
