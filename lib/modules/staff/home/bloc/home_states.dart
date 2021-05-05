import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_student_count.dart';
import 'package:DigiMess/modules/staff/home/data/models/home_students_present.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class StaffHomeStates extends Equatable {
  const StaffHomeStates();
}

class StaffHomeLoading extends StaffHomeStates {
  @override
  List<Object> get props => [];
}

class StaffHomeIdle extends StaffHomeStates {
  @override
  List<Object> get props => [];
}

class StaffHomeFetchSuccess extends StaffHomeStates {
  final List<MenuItem> listOfTodaysMeals;
  final List<Notice> latestNotice;
  final StudentEnrolledCount studentEnrolledCount;
  final StudentPresentCount studentPresentCount;

  StaffHomeFetchSuccess(
      {@required this.listOfTodaysMeals,
      @required this.latestNotice,
      @required this.studentEnrolledCount,
      @required this.studentPresentCount});

  @override
  List<Object> get props => [
        this.listOfTodaysMeals,
        this.latestNotice,
        this.studentPresentCount,
        this.studentEnrolledCount
      ];
}

class StaffHomeError extends StaffHomeStates {
  final DMError errors;

  StaffHomeError(this.errors);

  @override
  List<Object> get props => [this.errors];
}
