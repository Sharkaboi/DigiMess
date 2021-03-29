import 'package:DigiMess/common/extensions/int_extensions.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:flutter/material.dart';

class DummyPaymentsScreen extends StatelessWidget {
  final String message;
  final int paymentAmount;
  final VoidCallback paymentSuccessCallback;

  const DummyPaymentsScreen(
      {Key key, this.paymentAmount, this.message, this.paymentSuccessCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DMScaffold(
        isAppBarRequired: false,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              color: DMColors.primaryBlue,
              child: Container(
                margin: EdgeInsets.only(top: 140.0, bottom: 20),
                child: Text(
                  "For\n$message",
                  style: DMTypo.bold24WhiteTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Text(
                "Amount to be paid",
                style: DMTypo.bold24BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              child: Text(
                paymentAmount.getFormattedCurrency(),
                style: DMTypo.bold48BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: Text(
                "To DigiMess",
                style: DMTypo.bold24MutedTextStyle,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 70,
                    child: Hero(
                      tag: "proceedBtn",
                      child: DarkButton(
                          text: "Pay Now",
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.PAYMENT_CARD_DETAILS_SCREEN,
                                arguments: paymentSuccessCallback);
                          }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
