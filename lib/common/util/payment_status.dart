import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PaymentStatus extends Equatable {
  final bool hasPaidFees;
  final DateTime lastPaymentDate;

  PaymentStatus({@required this.hasPaidFees, @required this.lastPaymentDate});

  @override
  List<Object> get props => [this.hasPaidFees, this.lastPaymentDate];
}
