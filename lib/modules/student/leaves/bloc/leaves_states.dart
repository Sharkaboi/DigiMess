import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:equatable/equatable.dart';

abstract class StudentLeaveStates extends Equatable {
  const StudentLeaveStates();
}

class StudentLeaveIdle extends StudentLeaveStates {
  @override
  List<Object> get props => [];
}

class StudentLeaveLoading extends StudentLeaveStates {
  @override
  List<Object> get props => [];
}

class StudentLeaveError extends StudentLeaveStates {
  final DMError error;

  StudentLeaveError(this.error);

  @override
  List<Object> get props => [error];
}

class StudentLeaveFetchSuccess extends StudentLeaveStates {
  final List<LeaveEntry> listOfLeaves;

  StudentLeaveFetchSuccess(this.listOfLeaves);

  @override
  List<Object> get props => [listOfLeaves];
}

class StudentLeaveSuccess extends StudentLeaveStates {
  @override
  List<Object> get props => [];
}
