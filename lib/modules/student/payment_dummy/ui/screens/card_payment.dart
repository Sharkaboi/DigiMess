import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amount_configuration_screen/otp_screen.dart';
import 'package:amount_configuration_screen/amount_screen.dart';


class CardPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 150.0,
                width: (MediaQuery.of(context).size.width),
                color: Color(0xff317BE1),
                child: Container(
                  margin: EdgeInsets.only(top:40.0),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => AmountScreen())));
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 0.0),
                        child: Text(
                          "CARD PAYMENT",
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Comfortaa',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20.0, 45.0, 0.0, 0.0),
                        child: Icon(
                          Icons.credit_card_outlined,
                          color: Colors.white,
                          size: 35.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 150.0,top: 30.0),
                child: Text(
                  "Card Number :",
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Comfortaa',
                  ),
                ),
              ),
              Container(
                height: 60.0,
                width: 290.0,
                margin: EdgeInsets.only(right:20.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    errorText: null,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Comfortaa',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0.0),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 35.0,top: 30.0),
                            child: Text(
                              "Expiration Date :",
                              style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Comfortaa',
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 0.0,top: 0.0),
                            width: 170.0,
                            child: TextField(
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                errorText: null,
                                hintText: "MM-YYYY",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontFamily: 'Comfortaa',

                                ),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 7,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Comfortaa',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 35.0,top: 25.0),
                            child: Text(
                              "CVV :",
                              style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Comfortaa',
                              ),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            width: 40.0,
                            margin: EdgeInsets.only(left: 35.0,top: 15.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                errorText: null,
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              obscureText: true,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontFamily: 'Comfortaa',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 80.0,top: 30.0),
                child: Text(
                  "Card Holder's Name:",
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Comfortaa',
                  ),
                ),
              ),
              Container(
                height: 50.0,
                width: 290.0,
                margin: EdgeInsets.only(right: 30.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    errorText: null,
                  ),
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Comfortaa',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 150.0),
                child: SizedBox(
                  height: 45.0,
                  width: 255.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xff0038CF),
                      child: Text(
                        "Proceed",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => OtpScreen())));
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
      ),
    );
  }
}



