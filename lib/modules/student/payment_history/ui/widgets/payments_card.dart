import 'package:DigiMess/common/extensions/int_extensions.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentsCard extends StatelessWidget {
  final Payment payment;

  const PaymentsCard({Key key, this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.circle,
                        color: DMColors.green,
                        size: 15,
                      ),
                    ),
                    Text("Paid on", style: DMTypo.bold14BlackTextStyle),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(left: 25),
                    child: Text(getDate(), style: DMTypo.bold12MutedTextStyle)),
                Container(
                    margin: EdgeInsets.only(top: 30, left: 25),
                    child: Text(payment.description,
                        style: DMTypo.bold12BlackTextStyle))
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(getCurrency(), style: DMTypo.bold18GreenTextStyle))
        ],
      ),
    );
  }

  String getDate() {
    if (payment != null && payment.paymentDate != null) {
      return DateFormat("MMM d yyyy").format(payment.paymentDate);
    } else {
      return "Invalid date";
    }
  }

  String getCurrency() {
    if (payment != null && payment.paymentAmount != null) {
      return payment.paymentAmount.getFormattedCurrency();
    } else {
      return "Invalid amount";
    }
  }
}
