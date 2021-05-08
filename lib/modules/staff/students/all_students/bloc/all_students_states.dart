import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class AllStudentsStates extends Equatable {
  const AllStudentsStates();
}

class AllStudentsIdle extends AllStudentsStates {
  @override
  List<Object> get props => [];
}

class AllStudentsLoading extends AllStudentsStates {
  @override
  List<Object> get props => [];
}

class AllStudentsSuccess extends AllStudentsStates {
  final List<User> listOfUsers;

  AllStudentsSuccess(this.listOfUsers);

  @override
  List<Object> get props => [listOfUsers];
}

class AllStudentsError extends AllStudentsStates {
  final DMError error;

  AllStudentsError(this.error);

  @override
  List<Object> get props => [error];
}
