import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentDetailsStates extends Equatable {
  const StudentDetailsStates();
}

class StudentDetailsIdle extends StudentDetailsStates {
  @override
  List<Object> get props => [];
}

class StudentDetailsLoading extends StudentDetailsStates {
  @override
  List<Object> get props => [];
}

class StudentDetailsDisableSuccess extends StudentDetailsStates {
  @override
  List<Object> get props => [];
}

class StudentDetailsError extends StudentDetailsStates {
  final DMError error;

  StudentDetailsError(this.error);

  @override
  List<Object> get props => [error];
}
