import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:equatable/equatable.dart';

abstract class StudentHomeEvents extends Equatable {
  const StudentHomeEvents();
}

class FetchStudentHomeDetails extends StudentHomeEvents {
  @override
  List<Object> get props => [];
}

class MakePayment extends StudentHomeEvents {
  final Payment payment;

  MakePayment(this.payment);

  @override
  List<Object> get props => [payment];
}
