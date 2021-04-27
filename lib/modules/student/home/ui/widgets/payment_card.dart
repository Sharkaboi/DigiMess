import 'package:DigiMess/common/constants/dm_details.dart';
import 'package:DigiMess/common/constants/enums/payment_account_type.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/extensions/int_extensions.dart';
import 'package:DigiMess/common/firebase/models/payment.dart';
import 'package:DigiMess/common/router/routes.dart';
import 'package:DigiMess/common/util/payment_status.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:DigiMess/modules/student/payment_dummy/util/dummy_payment_args.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePaymentCard extends StatefulWidget {
  final PaymentStatus paymentStatus;
  final int lastMonthLeaveCount;
  final Function(Payment) onPaymentSuccessCallback;

  const HomePaymentCard(
      {Key key,
      this.paymentStatus,
      this.lastMonthLeaveCount,
      this.onPaymentSuccessCallback})
      : super(key: key);

  @override
  _HomePaymentCardState createState() => _HomePaymentCardState();
}

class _HomePaymentCardState extends State<HomePaymentCard> {
  int amount = 0;
  String dueDateHint = "";
  String description = "";

  @override
  void initState() {
    super.initState();
    amount = getPaymentAmount();
    description = getDescription();
    dueDateHint = getDueDate();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.paymentStatus.hasPaidFees,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
            .copyWith(top: 10),
        decoration: BoxDecoration(
            color: DMColors.primaryBlue,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(getDueFees(context),
                          style: DMTypo.bold30WhiteTextStyle)),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child:
                        Text(getDueDate(), style: DMTypo.bold12WhiteTextStyle),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: DMPillButton(
                  isEnabled: amount > 0,
                  onPressed: () async {
                    Navigator.pushNamed(context, Routes.DUMMY_PAYMENT_SCREEN,
                        arguments:
                            DummyPaymentArguments(description, amount, () {
                          // ignore: missing_required_param
                          widget.onPaymentSuccessCallback(Payment(
                              description: description,
                              paymentAccountType: PaymentAccountType.CARD,
                              paymentAmount: amount,
                              paymentDate: DateTime.now()));
                        }));
                  },
                  onDisabledPressed: () async {
                    DMSnackBar.show(context,
                        "An error has occurred with fee calculation, contact the admin from the help section.");
                  },
                  text: "Pay Now",
                  textStyle: DMTypo.bold14WhiteTextStyle,
                  padding: EdgeInsets.symmetric(horizontal: 20)),
            )
          ],
        ),
      ),
    );
  }

  String getDueFees(context) {
    return amount.getFormattedCurrency(isSymbol: false);
  }

  String getDueDate() {
    final monthNameFormat = DateFormat("MMMM");
    final DateTime today = DateTime.now();
    if (widget.paymentStatus.lastPaymentDate.isLastMonthOf(today) &&
        DateExtensions.isBeforeDueDate()) {
      return "Due 7th ${monthNameFormat.format(today)}";
    } else {
      return "Was due 7th ${monthNameFormat.format(widget.paymentStatus.lastPaymentDate.copyWith(month: widget.paymentStatus.lastPaymentDate.month + 1))}";
    }
  }

  String getDescription() {
    final monthYearFormat = DateFormat("MMMM yyyy");
    final DateTime today = DateTime.now();
    if (widget.paymentStatus.lastPaymentDate.isLastMonthOf(today) &&
        DateExtensions.isBeforeDueDate()) {
      return "Fees of ${monthYearFormat.format(today)}";
    } else {
      return "Fees of ${monthYearFormat.format(widget.paymentStatus.lastPaymentDate.copyWith(month: widget.paymentStatus.lastPaymentDate.month + 1))}";
    }
  }

  int getPaymentAmount() {
    final int noOfDaysInMonth = widget.paymentStatus.lastPaymentDate
        .copyWith(month: widget.paymentStatus.lastPaymentDate.month + 1, day: 0)
        .day;
    if (noOfDaysInMonth < widget.lastMonthLeaveCount || noOfDaysInMonth < 28) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DMSnackBar.show(context,
            "An error has occurred with fee calculation, contact the admin from the help section.");
      });
      return 0;
    } else {
      final DateTime today = DateTime.now();
      final int daysSinceDue = widget.paymentStatus.lastPaymentDate
          .copyWith(
              month: widget.paymentStatus.lastPaymentDate.month + 1, day: 7)
          .difference(today)
          .inDays
          .abs();
      final int amount = DMDetails.constantMessPrice +
          ((noOfDaysInMonth - widget.lastMonthLeaveCount) *
              DMDetails.dailyMessPrice) +
          (daysSinceDue * DMDetails.dailyFinePrice);
      print("lastPaymentDate: ${widget.paymentStatus.lastPaymentDate}\n"
          "hasPaidFees: ${widget.paymentStatus.hasPaidFees}\n"
          "noOfDaysInDueMonth : $noOfDaysInMonth\n"
          "lastMonthLeaveCount : ${widget.lastMonthLeaveCount}\n"
          "daysSinceDue : $daysSinceDue\namount : $amount");
      if (amount < 0)
        return 0;
      else
        return amount;
    }
  }
}
