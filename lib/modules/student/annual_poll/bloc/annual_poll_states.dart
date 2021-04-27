import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentAnnualPollStates extends Equatable {
  const StudentAnnualPollStates();
}

class StudentAnnualPollIdle extends StudentAnnualPollStates {
  @override
  List<Object> get props => [];
}

class StudentAnnualPollLoading extends StudentAnnualPollStates {
  @override
  List<Object> get props => [];
}

class StudentAnnualPollFetchSuccess extends StudentAnnualPollStates {
  final List<MenuItem> listOfItems;

  StudentAnnualPollFetchSuccess(this.listOfItems);

  @override
  List<Object> get props => [listOfItems];
}

class StudentVoteSuccess extends StudentAnnualPollStates {
  StudentVoteSuccess();

  @override
  List<Object> get props => [];
}

class StudentAnnualPollError extends StudentAnnualPollStates {
  final DMError error;

  StudentAnnualPollError(this.error);

  @override
  List<Object> get props => [error];
}
