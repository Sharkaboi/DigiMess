import 'package:DigiMess/common/errors/error_wrapper.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:equatable/equatable.dart';

abstract class StudentPaymentsStates extends Equatable {
  const StudentPaymentsStates();
}

class StudentPaymentsIdle extends StudentPaymentsStates {
  @override
  List<Object> get props => [];
}

class StudentPaymentsLoading extends StudentPaymentsStates {
  @override
  List<Object> get props => [];
}

class StudentPaymentsSuccess extends StudentPaymentsStates {
  final List<Payment> listOfPayments;

  StudentPaymentsSuccess(this.listOfPayments);

  @override
  List<Object> get props => [listOfPayments];
}

class StudentPaymentsError extends StudentPaymentsStates {
  final DMError error;

  StudentPaymentsError(this.error);

  @override
  List<Object> get props => [error];
}
