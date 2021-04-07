import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/modules/student/payment_dummy/util/dummy_payment_args.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePaymentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 20, vertical: 20).copyWith(top: 10),
      decoration: BoxDecoration(
          color: DMColors.primaryBlue, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child:
                        Text(getDueFees(), style: DMTypo.bold30WhiteTextStyle)),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(getDueDate(), style: DMTypo.bold12WhiteTextStyle),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: DMPillButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.DUMMY_PAYMENT_SCREEN,
                      arguments:
                          DummyPaymentArguments("Fees of 2020", 4000, () {
                        print("success");
                      }));
                },
                text: "Pay Now",
                textStyle: DMTypo.bold14WhiteTextStyle,
                padding: EdgeInsets.symmetric(horizontal: 20)),
          )
        ],
      ),
    );
  }

  String getDueFees() {
    // todo : get fees according to leaves and fines
    return "3000".getFormattedCurrency(isSymbol: false);
  }

  String getDueDate() {
    final month = DateFormat("MMMM").format(DateTime.now());
    if (DateExtensions.isBeforeDueDate()) {
      return "Due 7th $month";
    } else {
      return "Was due 7th $month";
    }
  }
}
