import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:DigiMess/common/widgets/dm_buttons.dart';
import 'package:DigiMess/common/widgets/dm_date_picker.dart';
import 'package:DigiMess/common/widgets/dm_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaceLeaveCard extends StatefulWidget {
  final Function(DateTimeRange) onLeaveSubmit;
  final bool isLeaveOngoing;

  const PlaceLeaveCard({Key key, this.onLeaveSubmit, this.isLeaveOngoing})
      : super(key: key);

  @override
  _PlaceLeaveCardState createState() => _PlaceLeaveCardState();
}

class _PlaceLeaveCardState extends State<PlaceLeaveCard> {
  DateTime startDate;
  DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text("From")),
                Container(
                  child: Container(width: 55, height: 15),
                ),
                Expanded(
                  child: Text("To"),
                ),
              ],
            ),
          ),
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  child: Material(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () => showStartDatePickerAndAwait(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: DMColors.primaryBlue, width: 1)),
                        child: Center(child: getFromStartDate()),
                      ),
                    ),
                  ),
                )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.arrow_forward_ios,
                      color: DMColors.primaryBlue, size: 15),
                ),
                Expanded(
                    child: Container(
                  child: Material(
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () => showEndDatePickerAndAwait(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: DMColors.primaryBlue, width: 1)),
                        child: Center(child: getFromEndDate()),
                      ),
                    ),
                  ),
                )),
              ]),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text(getIntervalDuration(),
                  style: DMTypo.bold14BlackTextStyle)),
          DarkButton(
            text: "Submit",
            isEnabled: !widget.isLeaveOngoing,
            textStyle: DMTypo.bold14WhiteTextStyle,
            padding: EdgeInsets.symmetric(horizontal: 30),
            onPressed: () {
              if (startDate == null || endDate == null) {
                DMSnackBar.show(context, "Choose an interval first");
              } else {
                widget.onLeaveSubmit(
                    DateTimeRange(start: startDate, end: endDate));
              }
            },
            onDisabledPressed: () {
              DMSnackBar.show(context, "Leave is already ongoing");
            },
          )
        ],
      ),
    );
  }

  void showStartDatePickerAndAwait(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime pickerStartDate =
        DateExtensions.isNightTime() ? now.add(Duration(days: 1)) : now;
    final DateTime pickedDate = await DMDatePicker.showPicker(context,
        firstDate: pickerStartDate, initialDate: pickerStartDate);
    setState(() {
      if (pickedDate != null) {
        if (endDate != null) endDate = null;
        startDate = pickedDate;
      }
    });
  }

  void showEndDatePickerAndAwait(BuildContext context) async {
    if (startDate == null) {
      DMSnackBar.show(context, "Choose start date first.");
      return;
    }
    final DateTime pickerStartDate = startDate.add(Duration(days: 1));
    final DateTime pickerEndDate = startDate.add(Duration(days: 61));
    final DateTime pickedDate = await DMDatePicker.showPicker(context,
        firstDate: pickerStartDate,
        initialDate: pickerStartDate,
        lastDate: pickerEndDate);
    setState(() {
      if (pickedDate != null) {
        endDate = pickedDate;
      }
    });
  }

  Text getFromStartDate() {
    if (startDate == null) {
      return Text("dd/mm/yyyy", style: DMTypo.bold12MutedTextStyle);
    } else {
      final DateFormat format = DateFormat("dd/MM/yyyy");
      return Text(format.format(startDate),
          style: DMTypo.bold12PrimaryBlueTextStyle);
    }
  }

  Text getFromEndDate() {
    if (endDate == null) {
      return Text("dd/mm/yyyy", style: DMTypo.bold12MutedTextStyle);
    } else {
      final DateFormat format = DateFormat("dd/MM/yyyy");
      return Text(format.format(endDate),
          style: DMTypo.bold12PrimaryBlueTextStyle);
    }
  }

  String getIntervalDuration() {
    if (startDate == null || endDate == null) {
      return "Number of days : 0";
    } else {
      return "Number of days : ${startDate.difference(endDate).inDays.abs()}";
    }
  }
}
