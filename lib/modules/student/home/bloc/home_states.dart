import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class StudentHomeStates extends Equatable {
  const StudentHomeStates();
}

class StudentHomeLoading extends StudentHomeStates {
  @override
  List<Object> get props => [];
}

class StudentHomeIdle extends StudentHomeStates {
  @override
  List<Object> get props => [];
}

class StudentHomeFetchSuccess extends StudentHomeStates {
  final List<MenuItem> listOfTodaysMeals;
  final List<Notice> latestNotice;
  final bool hasPaidFees;

  StudentHomeFetchSuccess(
      {@required this.listOfTodaysMeals,
      @required this.latestNotice,
      @required this.hasPaidFees});

  @override
  List<Object> get props =>
      [this.listOfTodaysMeals, this.latestNotice, this.hasPaidFees];
}

class StudentHomeError extends StudentHomeStates {
  final DMError errors;

  StudentHomeError(this.errors);

  @override
  List<Object> get props => [this.errors];
}
