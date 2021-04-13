import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StudentNoticesStates extends Equatable {
  const StudentNoticesStates();
}

class StudentNoticesIdle extends StudentNoticesStates {
  @override
  List<Object> get props => [];
}

class StudentNoticesLoading extends StudentNoticesStates {
  @override
  List<Object> get props => [];
}

class StudentNoticesSuccess extends StudentNoticesStates {
  final List<Notice> listOfNotices;

  StudentNoticesSuccess(this.listOfNotices);

  @override
  List<Object> get props => [listOfNotices];
}

class StudentNoticesError extends StudentNoticesStates {
  final DMError error;

  StudentNoticesError(this.error);

  @override
  List<Object> get props => [error];
}
