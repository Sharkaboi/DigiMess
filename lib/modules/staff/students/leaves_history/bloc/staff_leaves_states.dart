import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffStudentLeavesStates extends Equatable {
  const StaffStudentLeavesStates();
}

class StaffLeavesIdle extends StaffStudentLeavesStates {
  @override
  List<Object> get props => [];
}

class StaffLeavesLoading extends StaffStudentLeavesStates {
  @override
  List<Object> get props => [];
}

class StaffLeavesSuccess extends StaffStudentLeavesStates {
  final List<LeaveEntry> listOfLeaves;

  StaffLeavesSuccess(this.listOfLeaves);

  @override
  List<Object> get props => [listOfLeaves];
}

class StaffLeavesError extends StaffStudentLeavesStates {
  final DMError error;

  StaffLeavesError(this.error);

  @override
  List<Object> get props => [error];
}
