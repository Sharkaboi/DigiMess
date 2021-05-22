import 'package:DigiMess/common/firebase/models/menu_item.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffAnnualPollStates extends Equatable {
  const StaffAnnualPollStates();
}

class AnnualPollIdle extends StaffAnnualPollStates {
  @override
  List<Object> get props => [];
}

class AnnualPollLoading extends StaffAnnualPollStates {
  @override
  List<Object> get props => [];
}

class AnnualPollFetchSuccess extends StaffAnnualPollStates {
  final List<MenuItem> listOfItems;

  AnnualPollFetchSuccess(this.listOfItems);

  @override
  List<Object> get props => [listOfItems];
}

class AnnualPollResetSuccess extends StaffAnnualPollStates {
  @override
  List<Object> get props => [];
}

class AnnualPollError extends StaffAnnualPollStates {
  final DMError error;

  AnnualPollError(this.error);

  @override
  List<Object> get props => [error];
}
