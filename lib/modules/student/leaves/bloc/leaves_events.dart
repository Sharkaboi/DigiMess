import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class StudentLeaveEvents extends Equatable {
  const StudentLeaveEvents();
}

class GetAllLeaves extends StudentLeaveEvents {
  @override
  List<Object> get props => [];
}

class PlaceLeave extends StudentLeaveEvents {
  final DateTimeRange leaveInterval;

  PlaceLeave(this.leaveInterval);

  @override
  List<Object> get props => [leaveInterval];
}
