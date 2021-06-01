import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/util/error_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class StaffPaymentsStates extends Equatable {
  const StaffPaymentsStates();
}

class StaffPaymentsIdle extends StaffPaymentsStates {
  @override
  List<Object> get props => [];
}

class StaffPaymentsLoading extends StaffPaymentsStates {
  @override
  List<Object> get props => [];
}

class StaffPaymentsSuccess extends StaffPaymentsStates {
  final List<Payment> listOfPayments;

  StaffPaymentsSuccess(this.listOfPayments);

  @override
  List<Object> get props => [listOfPayments];
}

class StaffPaymentsError extends StaffPaymentsStates {
  final DMError error;

  StaffPaymentsError(this.error);

  @override
  List<Object> get props => [error];
}
