import 'package:equatable/equatable.dart';

abstract class StaffPaymentsEvents extends Equatable {
  const StaffPaymentsEvents();
}

class GetAllPayments extends StaffPaymentsEvents {
  final String userId;

  GetAllPayments(this.userId);

  @override
  List<Object> get props => [];
}
