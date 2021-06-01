import 'package:flutter/foundation.dart';

class DummyPaymentArguments {
  final String message;
  final int paymentAmount;
  final AsyncCallback paymentSuccessCallback;

  DummyPaymentArguments(this.message, this.paymentAmount, this.paymentSuccessCallback);
}
