import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffNoticesStates extends Equatable {
  const StaffNoticesStates();
}

class NoticesIdle extends StaffNoticesStates {
  @override
  List<Object> get props => [];
}

class NoticesLoading extends StaffNoticesStates {
  @override
  List<Object> get props => [];
}

class PlaceNoticesSuccess extends StaffNoticesStates {
  @override
  List<Object> get props => [];
}

class NoticesFetchSuccess extends StaffNoticesStates {
  final List<Notice> listOfNotices;

  NoticesFetchSuccess(this.listOfNotices);

  @override
  List<Object> get props => [listOfNotices];
}

class NoticesError extends StaffNoticesStates {
  final DMError error;

  NoticesError(this.error);

  @override
  List<Object> get props => [error];
}
