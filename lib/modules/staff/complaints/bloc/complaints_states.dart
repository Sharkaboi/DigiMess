import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class ComplaintsStates extends Equatable {
  const ComplaintsStates();
}

class ComplaintsIdle extends ComplaintsStates {
  @override
  List<Object> get props => [];
}

class ComplaintsLoading extends ComplaintsStates {
  @override
  List<Object> get props => [];
}

class ComplaintsSuccess extends ComplaintsStates {
  final List<Complaint> listOfComplaints;

  ComplaintsSuccess(this.listOfComplaints);

  @override
  List<Object> get props => [listOfComplaints];
}

class ComplaintsError extends ComplaintsStates {
  final DMError error;

  ComplaintsError(this.error);

  @override
  List<Object> get props => [error];
}