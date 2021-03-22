import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amount_configuration_screen/amount_screen.dart';
import 'package:flutter/src/widgets/framework.dart';


class PaymentSuccess extends StatefulWidget {
  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState(){
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AmountScreen() ));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff317BE1),
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 230.0),
                child:  Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 200.0,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:20.0),

                child: Text(
                  "Payment Successful !",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Comfortaa',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

