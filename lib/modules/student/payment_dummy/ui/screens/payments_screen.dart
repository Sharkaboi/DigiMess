import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  final String message;
  final int paymentAmount;
  final VoidCallback paymentSuccessCallback;

  const PaymentsScreen(
      {Key key, this.paymentAmount, this.message, this.paymentSuccessCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
