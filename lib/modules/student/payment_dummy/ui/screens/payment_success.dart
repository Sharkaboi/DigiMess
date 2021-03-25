import 'dart:async';

import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';

class PaymentSuccess extends StatefulWidget {
  final VoidCallback paymentSuccessCallback;

  const PaymentSuccess({Key key, this.paymentSuccessCallback})
      : super(key: key);

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState() {
    super.initState();
    widget.paymentSuccessCallback();
    Timer(Duration(seconds: 3), () {
      int i = 4;
      while (i > 0 && Navigator.canPop(context)) {
        i--;
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: DMColors.primaryBlue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 160,
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "Payment Successful!",
                  style: DMTypo.bold24WhiteTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
