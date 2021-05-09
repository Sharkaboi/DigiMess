import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OngoingLeaveCard extends StatelessWidget {
  final LeaveEntry leave;

  const OngoingLeaveCard({Key key, this.leave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            children: [
              Text("From", style: DMTypo.bold16BlackTextStyle),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(getStartDate(), style: DMTypo.normal14BlackTextStyle))
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Text("To", style: DMTypo.bold16BlackTextStyle),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(getEndDate(), style: DMTypo.normal14BlackTextStyle))
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Text("Duration", style: DMTypo.bold16BlackTextStyle),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(getDuration(), style: DMTypo.normal14BlackTextStyle))
            ],
          ))
        ],
      ),
    );
  }

  String getStartDate() {
    if (leave.startDate != null) {
      final DateFormat format = DateFormat("MMMM d");
      return format.format(leave.startDate);
    } else {
      return "N/A";
    }
  }

  String getEndDate() {
    if (leave.endDate != null) {
      final DateFormat format = DateFormat("MMMM d");
      return format.format(leave.endDate);
    } else {
      return "N/A";
    }
  }

  String getDuration() {
    if (leave == null || leave.startDate == null || leave.endDate == null) {
      return "N/A";
    } else {
      return leave.endDate.difference(leave.startDate).inDays.abs().toString();
    }
  }
}
