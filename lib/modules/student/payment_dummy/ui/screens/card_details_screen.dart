import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardDetailsScreen extends StatelessWidget {
  final VoidCallback paymentSuccessCallback;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  CardDetailsScreen({Key key, this.paymentSuccessCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DMScaffold(
      isAppBarRequired: false,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  color: DMColors.primaryBlue,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: DMColors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Card Payment",
                          style: DMTypo.bold24WhiteTextStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: SvgPicture.asset(
                          "assets/icons/card.svg",
                          height: 20,
                          color: DMColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Text(
                    "Card Number :",
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "0000 0000 0000 0000",
                        isDense: true,
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: DMColors.primaryBlue, width: 2)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: DMColors.primaryBlue, width: 2)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: DMColors.primaryBlue, width: 2)),
                        counterText: "",
                      ),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 19,
                      inputFormatters: [
                        MaskedInputFormatter("#### #### #### ####",
                            anyCharMatcher: RegExp(r'[0-9]+'))
                      ],
                      style: DMTypo.bold18BlackTextStyle,
                      validator: (value) {
                        final regex = RegExp(r"\d{4} \d{4} \d{4} \d{4}");
                        final bool match = regex.hasMatch(value);
                        return match ? null : "Invalid card number";
                      }),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Expiration Date :",
                              style: DMTypo.bold18BlackTextStyle,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                isDense: true,
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: DMColors.primaryBlue, width: 2)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: DMColors.primaryBlue, width: 2)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: DMColors.primaryBlue, width: 2)),
                                counterText: "",
                                hintText: "MM/YY",
                                hintStyle: DMTypo.bold18MutedTextStyle,
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              maxLines: 1,
                              validator: (value) {
                                final regex = RegExp(r"\d{2}/\d{2}");
                                final bool match = regex.hasMatch(value);
                                return match ? null : "Invalid format";
                              },
                              inputFormatters: [
                                CreditCardExpirationDateFormatter()
                              ],
                              style: DMTypo.bold18BlackTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "CVV :",
                                style: DMTypo.bold18BlackTextStyle,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: DMColors.primaryBlue,
                                          width: 2)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: DMColors.primaryBlue,
                                          width: 2)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: DMColors.primaryBlue,
                                          width: 2)),
                                  counterText: "",
                                  hintText: "XXX",
                                  hintStyle: DMTypo.bold18MutedTextStyle,
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                maxLines: 1,
                                validator: (value) =>
                                    value.length == 3 ? null : "Invalid cvv",
                                obscureText: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: DMTypo.bold18BlackTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20.0, top: 30.0),
                  child: Text(
                    "Card Holder's Name:",
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20, right: 20.0, top: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      isDense: true,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: DMColors.primaryBlue, width: 2)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: DMColors.primaryBlue, width: 2)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: DMColors.primaryBlue, width: 2)),
                      counterText: "",
                      hintText: "John Doe",
                      hintStyle: DMTypo.bold18MutedTextStyle,
                    ),
                    keyboardType: TextInputType.name,
                    maxLength: 20,
                    maxLines: 1,
                    validator: (value) =>
                        value.isNotEmpty ? null : "Enter a name",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: DMTypo.bold18BlackTextStyle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 50, horizontal: 20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 70,
                          child: Hero(
                            tag: "proceedBtn",
                            child: DarkButton(
                                text: "Proceed",
                                onPressed: () {
                                  if (_key.currentState.validate()) {
                                    Navigator.pushNamed(
                                        context, Routes.PAYMENT_OTP_SCREEN,
                                        arguments: paymentSuccessCallback);
                                  }
                                }),
                          ),
                        )
                      ],
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
