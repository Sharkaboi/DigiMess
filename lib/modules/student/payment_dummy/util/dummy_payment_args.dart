import 'package:flutter/material.dart';

class DummyPaymentArguments {
  final String message;
  final int paymentAmount;
  final VoidCallback paymentSuccessCallback;

  DummyPaymentArguments(
      this.message, this.paymentAmount, this.paymentSuccessCallback);
}
