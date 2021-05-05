import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StudentPresentCount extends Equatable {
  final int studentsPresent;
  final int studentsPresentVeg;
  final int studentsPresentNonVeg;

  StudentPresentCount(
      {@required this.studentsPresent,
      @required this.studentsPresentVeg,
      @required this.studentsPresentNonVeg});

  @override
  List<Object> get props =>
      [this.studentsPresent, this.studentsPresentVeg, this.studentsPresentNonVeg];
}
