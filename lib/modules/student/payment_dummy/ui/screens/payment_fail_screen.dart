import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentFailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/failed.svg',
                    color: DMColors.primaryBlue, height: 200, width: 160),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Text(
                    "Payment Failed! ☹",
                    style: DMTypo.bold24PrimaryBlueTextStyle,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 70,
                  child: Hero(
                    tag: "proceedBtn",
                    child: DMPillButton(
                      text: "Try Again",
                      onPressed: () => navigateBackToDummyPayment(context),
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

  void navigateBackToDummyPayment(BuildContext context) {
    int i = 3;
    while (i > 0 && Navigator.canPop(context)) {
      i--;
      Navigator.pop(context);
    }
  }
}
