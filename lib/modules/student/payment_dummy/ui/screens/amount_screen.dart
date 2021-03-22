import 'package:amount_configuration_screen/card_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amount_configuration_screen/card_payment.dart';


class AmountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 220.0,
                width: (MediaQuery.of(context).size.width),
                color: Color(0xff317BE1),
                child: Container(
                  margin: EdgeInsets.only(top:140.0),
                  child: Column(
                    children: [
                      Text(
                        "For",
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                      Text(
                        "Caution Deposit",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 45.0),
                      child: Text(
                        "Amount to be paid",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Rs. 3000",
                        style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: Text(
                        "To DigiMess",
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 210.0),
                      child: SizedBox(
                        height: 60.0,
                        width: 255.0,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.0, right: 0.0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Color(0xff0038CF),
                            child: Text(
                              "PAY NOW",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Comfortaa',
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => CardPayment())));
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


