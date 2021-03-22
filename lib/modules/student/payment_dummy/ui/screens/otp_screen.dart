import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:amount_configuration_screen/payment_success.dart';
import 'package:amount_configuration_screen/payment_fail.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

String otpReceived = "";
class _OtpScreenState extends State<OtpScreen> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('app_icon');
    var initializationsSettings =
    new InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,);
  }

  Future _showNotification() async {


    Random random = new Random();
    int digits = random.nextInt(9000)+1000;
    String otpSent = digits.toString();
    otpReceived = otpSent;

    var androidDetails = new AndroidNotificationDetails(
        "App ID", "DigiMess", "This is a mess app",
        importance: Importance.max);
    var generalNotificationDetails =
    new NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
        0, "DigiMess OTP","$otpSent",
        generalNotificationDetails, payload: "DigiMess");
  }

  @override
  Widget build(BuildContext context) {
    _showNotification();
    String otpCollect = "";
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 120.0),
                  child: SvgPicture.asset('assets/mail_symbol.svg'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Text(
                    "Verification",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Text(
                    "You will receive an OTP via SMS",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Container(
                    width: 200.0,
                    child: PinCodeTextField(
                      keyboardType: TextInputType.number,
                      appContext: context,
                      autoDismissKeyboard: true,
                      animationType: AnimationType.fade,
                      obscureText: true,
                      blinkWhenObscuring: true,
                      textStyle:TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Comfortaa',
                      ),
                      length: 4,
                      onChanged: (value) {
                        otpCollect = value;
                        //print(otpCollect);
                      },
                      pinTheme: PinTheme(
                        inactiveColor: Colors.black,
                        selectedColor: Colors.greenAccent[700],
                        activeColor: Color(0xff317BE1),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40.0),
                  child: SizedBox(
                    height: 45.0,
                    width: 255.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color(0xff0038CF),
                        child: Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Comfortaa',
                          ),
                        ),
                        onPressed: () {
                          if(otpReceived == otpCollect ){
                            Random rnd = new Random();
                            int trial = rnd.nextInt(10);
                            if (trial == 0){
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => PaymentFail())));
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => PaymentSuccess())));
                            }
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => PaymentFail())));
                          }
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0,left: 50.0),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Text(
                          "Didn't receive an OTP ?",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontFamily: 'Comfortaa',
                          ),
                        ),
                      ),
                      Container(
                        child: InkWell(
                          child: Text(
                            "Send again",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff317BE1),
                              fontFamily: 'Comfortaa',
                            ),
                          ),
                          onTap: () => {
                            _showNotification()
                          },
                        ),
                      ),
                    ],
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
