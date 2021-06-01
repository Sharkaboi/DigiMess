import 'package:DigiMess/common/constants/enums/branch_types.dart';
import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserDetails extends Equatable {
  final String username;
  final String unhashedPassword;
  final UserType accountType;
  final bool isEnrolled;
  final int cautionDepositAmount;
  final String name;
  final DateTime yearOfAdmission;
  final DateTime yearOfCompletion;
  final Branch branch;
  final DateTime dob;
  final String phoneNumber;
  final String email;
  final bool isVeg;

  UserDetails(
      {
      @required this.username,
      @required this.unhashedPassword,
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

  @override
  List<Object> get props => [
        this.username,
        this.unhashedPassword,
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
