import 'dart:math';

import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final VoidCallback paymentSuccessCallback;

  const OtpScreen({Key key, this.paymentSuccessCallback}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String currentOtp = "";
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationsSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
    );

    _showNotification();
  }

  Future<void> _showNotification() async {
    final Random random = Random();
    final int otp = 1000 + random.nextInt(8999);
    currentOtp = otp.toString();

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
            "com.sharkaboi.DigiMess",
            "OTP Notification channel",
            "Notification channel for showing dummy OTP for payments.",
            importance: Importance.max);
    final NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, "OTP for payment in DigiMess",
        currentOtp, generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      isAppBarRequired: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 120),
                child: SvgPicture.asset('assets/icons/mail.svg',
                    height: 160, width: 160),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text("Verification", style: DMTypo.bold30BlackTextStyle),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text("You will receive an OTP via SMS",
                    style: DMTypo.bold18MutedTextStyle),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Container(
                  width: 200,
                  child: PinCodeTextField(
                    keyboardType: TextInputType.number,
                    appContext: context,
                    controller: _controller,
                    autoDismissKeyboard: true,
                    onChanged: (_) {},
                    textStyle: DMTypo.bold24BlackTextStyle,
                    length: 4,
                    showCursor: false,
                    animationType: AnimationType.none,
                    pinTheme: PinTheme(
                      inactiveColor: DMColors.black,
                      selectedColor: DMColors.black,
                      activeColor: DMColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 70,
                child: Hero(
                  tag: "proceedBtn",
                  child: DMPillButton(
                    text: "Verify",
                    onPressed: verifyOtp,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive an OTP ?",
                      style: DMTypo.bold14MutedTextStyle,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: InkWell(
                        child: Text(
                          "Send again",
                          style: DMTypo.bold14PrimaryBlueTextStyle,
                        ),
                        onTap: () => {_showNotification()},
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

  void verifyOtp() {
    if (currentOtp == _controller.text) {
      Random rnd = Random();
      int trial = rnd.nextInt(1000);
      if (trial == 13) {
        Navigator.pushNamed(context, Routes.PAYMENT_FAILED_SCREEN);
      } else {
        Navigator.pushNamed(context, Routes.PAYMENT_SUCCESS_SCREEN,
            arguments: widget.paymentSuccessCallback);
      }
    } else {
      DMSnackBar.show(context, "Invalid OTP");
      print("$currentOtp != ${_controller.text}");
    }
  }
}
