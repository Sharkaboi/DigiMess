import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amount_configuration_screen/amount_screen.dart';


class PaymentFail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 230.0),
                  child:  SvgPicture.asset('assets/icons/failed.svg'),
                ),
                Container(
                  margin: EdgeInsets.only(top:5.0),

                  child: Text(
                    "Payment Failed ! ☹",
                    style: TextStyle(
                      color: Color(0xff317BE1),
                      fontSize: 26.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 105.0),
                  child: SizedBox(
                    height: 45.0,
                    width: 255.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color(0xff0038CF),
                        child: Text(
                          "Try Again",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Comfortaa',
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: ((context) => AmountScreen())));
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
      ),
    );
  }
}
