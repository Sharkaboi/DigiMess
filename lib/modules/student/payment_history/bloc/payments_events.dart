import 'package:equatable/equatable.dart';

abstract class StudentPaymentsEvents extends Equatable {
  const StudentPaymentsEvents();
}

class GetAllPayments extends StudentPaymentsEvents {
  @override
  List<Object> get props => [];
}
