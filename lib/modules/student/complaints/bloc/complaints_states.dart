import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentComplaintsStates extends Equatable {
  const StudentComplaintsStates();
}

class StudentComplaintsIdle extends StudentComplaintsStates {
  @override
  List<Object> get props => [];
}

class StudentComplaintsLoading extends StudentComplaintsStates {
  @override
  List<Object> get props => [];
}

class StudentComplaintsError extends StudentComplaintsStates {
  final DMError error;

  StudentComplaintsError(this.error);

  @override
  List<Object> get props => [error];
}

class StudentComplaintsSuccess extends StudentComplaintsStates {
  @override
  List<Object> get props => [];
}
