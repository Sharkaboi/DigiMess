import 'dart:async';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final VoidCallback paymentSuccessCallback;

  const PaymentSuccessScreen({Key key, this.paymentSuccessCallback})
      : super(key: key);

  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      int i = 4;
      while (i > 0 && Navigator.canPop(context)) {
        i--;
        Navigator.pop(context);
      }
      widget.paymentSuccessCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
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
      ),
    );
  }
}
