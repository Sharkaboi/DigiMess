import 'package:DigiMess/common/constants/payment_account_type.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Payment extends Equatable {
  final String paymentId;
  final String userId;
  final PaymentAccountType paymentAccountType;
  final DateTime paymentDate;
  final int paymentAmount;
  final String description;

  Payment(
      {@required this.paymentId,
      @required this.userId,
      @required this.paymentAccountType,
      @required this.paymentDate,
      @required this.paymentAmount,
      @required this.description});

  factory Payment.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    return Payment(
        paymentId: documentSnapshot.id,
        userId: documentData['userId'],
        paymentAccountType: PaymentAccountTypeExtensions.fromString(
            documentData['accountType']),
        paymentDate: getDateTimeOrNull(documentData['date']),
        paymentAmount: documentData['amount'],
        description: documentData['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'accountType': this.paymentAccountType.toStringValue(),
      'date': Timestamp.fromDate(this.paymentDate),
      'amount': this.paymentAmount,
      'description': this.description
    };
  }

  @override
  List<Object> get props => [
        this.paymentId,
        this.userId,
        this.paymentAccountType,
        this.paymentDate,
        this.paymentAmount,
        this.description
      ];
}