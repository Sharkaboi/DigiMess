import 'package:DigiMess/common/constants/enums/user_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppStatus extends Equatable {
  final UserType userType;
  final String userId;
  final bool isEnabledInFirebase;
  final String username;

  AppStatus(
      {@required this.userType,
      @required this.userId,
      @required this.isEnabledInFirebase,
      @required this.username});

  @override
  List<Object> get props =>
      [this.userType, this.userId, this.isEnabledInFirebase, this.username];

  AppStatus copyWith({userType, userId, isEnabledInFirebase, username}) {
    return AppStatus(
        isEnabledInFirebase: isEnabledInFirebase ?? this.isEnabledInFirebase,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        userType: userType ?? this.userType);
  }
}
