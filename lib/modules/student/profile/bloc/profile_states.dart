import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class StudentProfileStates extends Equatable {
  const StudentProfileStates();
}

class StudentProfileIdle extends StudentProfileStates {
  @override
  List<Object> get props => [];
}

class StudentProfileLoading extends StudentProfileStates {
  @override
  List<Object> get props => [];
}

class StudentProfileFetchSuccess extends StudentProfileStates {
  final User userDetails;

  StudentProfileFetchSuccess(this.userDetails);

  @override
  List<Object> get props => [userDetails];
}

class StudentCloseAccountSuccess extends StudentProfileStates {
  StudentCloseAccountSuccess();

  @override
  List<Object> get props => [];
}

class StudentProfileError extends StudentProfileStates {
  final DMError error;

  StudentProfileError(this.error);

  @override
  List<Object> get props => [error];
}
