import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StudentEnrolledCount extends Equatable {
  final int studentsEnrolled;
  final int studentsEnrolledVeg;
  final int studentsEnrolledNonVeg;

  StudentEnrolledCount(
      {@required this.studentsEnrolled,
      @required this.studentsEnrolledVeg,
      @required this.studentsEnrolledNonVeg});

  @override
  List<Object> get props =>
      [this.studentsEnrolled, this.studentsEnrolledVeg, this.studentsEnrolledNonVeg];
}
