import 'package:equatable/equatable.dart';

abstract class PaymentsEvents extends Equatable {
  const PaymentsEvents();
}

class GetAllPayments extends PaymentsEvents {
  @override
  List<Object> get props => [];
}
