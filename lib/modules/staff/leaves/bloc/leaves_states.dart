import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/modules/staff/leaves/data/util/leaves_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffLeavesStates extends Equatable {
  const StaffLeavesStates();
}

class StaffLeavesIdle extends StaffLeavesStates {
  @override
  List<Object> get props => [];
}

class StaffLeavesLoading extends StaffLeavesStates {
  @override
  List<Object> get props => [];
}

class StaffLeavesSuccess extends StaffLeavesStates {
  final List<LeavesWrapper> listOfLeaves;

  StaffLeavesSuccess(this.listOfLeaves);

  @override
  List<Object> get props => [listOfLeaves];
}

class StaffLeavesError extends StaffLeavesStates {
  final DMError error;

  StaffLeavesError(this.error);

  @override
  List<Object> get props => [error];
}
