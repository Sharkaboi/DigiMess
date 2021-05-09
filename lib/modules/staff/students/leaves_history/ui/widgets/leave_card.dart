import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class LeaveCard extends StatelessWidget {
  final LeaveEntry leave;

  const LeaveCard({Key key, this.leave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(getDuration(), style: DMTypo.bold36BlackTTextStyle),
          Text(getDayHint(), style: DMTypo.bold18BlackTextStyle),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(child: Text("From", style: DMTypo.bold14BlackTextStyle)),
                  Expanded(
                    child: Text(getStartDate(), style: DMTypo.bold12MutedTextStyle),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(child: Text("To", style: DMTypo.bold14BlackTextStyle)),
                  Expanded(child: Text(getEndDate(), style: DMTypo.bold12MutedTextStyle))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getDuration() {
    if (leave == null || leave.startDate == null || leave.endDate == null) {
      return "N/A";
    } else {
      return leave.endDate.difference(leave.startDate).inDays.abs().toString();
    }
  }

  String getStartDate() {
    if (leave.startDate != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(leave.startDate);
    } else {
      return "N/A";
    }
  }

  String getEndDate() {
    if (leave.endDate != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(leave.endDate);
    } else {
      return "N/A";
    }
  }

  String getDayHint() {
    if (leave == null || leave.startDate == null || leave.endDate == null) {
      return "N/A";
    } else {
      return leave.endDate.difference(leave.startDate).inDays.abs() == 1 ? "day" : "days";
    }
  }
}
