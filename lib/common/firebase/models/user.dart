import 'package:DigiMess/common/constants/branch_types.dart';
import 'package:DigiMess/common/constants/user_types.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String userId;
  final String username;
  final String hashedPassword;
  final UserType accountType;
  final bool isEnrolled;
  final int cautionDepositAmount;
  final String name;
  final DateTime yearOfAdmission;
  final DateTime yearOfCompletion;
  final Branch branch;
  final DateTime dob;
  final int phoneNumber;
  final String email;
  final bool isVeg;

  User(
      {@required this.userId,
      @required this.username,
      @required this.hashedPassword,
      @required this.accountType,
      @required this.isEnrolled,
      @required this.cautionDepositAmount,
      @required this.name,
      @required this.yearOfAdmission,
      @required this.yearOfCompletion,
      @required this.branch,
      @required this.dob,
      @required this.phoneNumber,
      @required this.email,
      @required this.isVeg});

  factory User.fromDocument(QueryDocumentSnapshot documentSnapshot) {
    final Map<String, dynamic> documentData = documentSnapshot.data();
    return User(
        userId: documentSnapshot.id,
        username: documentData['username'],
        hashedPassword: documentData['hashedPassword'],
        accountType: UserTypeExtensions.fromString(documentData['type']),
        isEnrolled: documentData['isEnrolled'],
        cautionDepositAmount: documentData['cautionDepositAmount'],
        name: documentData['details']['name'],
        yearOfAdmission:
            getDateTimeOrNull(documentData['details']['yearOfAdmission']),
        yearOfCompletion:
            getDateTimeOrNull(documentData['details']['yearOfCompletion']),
        branch: BranchExtensions.fromString(documentData['details']['branch']),
        dob: getDateTimeOrNull(documentData['details']['dob']),
        phoneNumber: documentData['details']['phone'],
        email: documentData['details']['email'],
        isVeg: documentData['details']['isVeg']);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'type': this.accountType.toStringValue(),
      'isEnrolled': this.isEnrolled,
      'hashedPassword': this.hashedPassword,
      'cautionDepositAmount': this.cautionDepositAmount,
      'details': {
        'name': this.name,
        'yearOfAdmission': Timestamp.fromDate(this.yearOfAdmission),
        'yearOfCompletion': Timestamp.fromDate(this.yearOfCompletion),
        'branch': this.branch.toStringValue(),
        'dob': Timestamp.fromDate(this.dob),
        'email': this.email,
        'isVeg': this.isVeg,
        'phone': this.phoneNumber
      }
    };
  }

  @override
  List<Object> get props => [
        this.userId,
        this.username,
        this.hashedPassword,
        this.accountType,
        this.isEnrolled,
        this.cautionDepositAmount,
        this.name,
        this.yearOfAdmission,
        this.yearOfCompletion,
        this.branch,
        this.dob,
        this.phoneNumber,
        this.email,
        this.isVeg
      ];
}
