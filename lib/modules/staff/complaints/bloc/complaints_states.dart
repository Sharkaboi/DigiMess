import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:DigiMess/modules/staff/complaints/data/util/complaint_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffComplaintsStates extends Equatable {
  const StaffComplaintsStates();
}

class ComplaintsIdle extends StaffComplaintsStates {
  @override
  List<Object> get props => [];
}

class ComplaintsLoading extends StaffComplaintsStates {
  @override
  List<Object> get props => [];
}

class ComplaintsSuccess extends StaffComplaintsStates {
  final List<ComplaintWrapper> listOfComplaints;

  ComplaintsSuccess(this.listOfComplaints);

  @override
  List<Object> get props => [listOfComplaints];
}

class ComplaintsError extends StaffComplaintsStates {
  final DMError error;

  ComplaintsError(this.error);

  @override
  List<Object> get props => [error];
}
