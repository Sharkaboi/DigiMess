import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            height: 30,
            width: 100,
            margin: EdgeInsets.all(20),
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "Pay Now",
                style: DMTypo.bold14WhiteTextStyle,
              ),
              color: DMColors.darkBlue,
              textColor: DMColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
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
