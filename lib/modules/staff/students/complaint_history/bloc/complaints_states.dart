import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffComplaintsStates extends Equatable {
  const StaffComplaintsStates();
}

class StaffComplaintsIdle extends StaffComplaintsStates {
  @override
  List<Object> get props => [];
}

class StaffComplaintsLoading extends StaffComplaintsStates {
  @override
  List<Object> get props => [];
}

class StaffComplaintsSuccess extends StaffComplaintsStates {
  final List<Complaint> listOfComplaints;

  StaffComplaintsSuccess(this.listOfComplaints);

  @override
  List<Object> get props => [listOfComplaints];
}

class StaffComplaintsError extends StaffComplaintsStates {
  final DMError error;

  StaffComplaintsError(this.error);

  @override
  List<Object> get props => [error];
}
