import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/leave_entry.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class LeaveEntryCard extends StatelessWidget {
  final LeaveEntry leaveEntry;
  final bool isOnGoingLeave;

  const LeaveEntryCard({Key key, this.leaveEntry, this.isOnGoingLeave = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              isOnGoingLeave
                  ? Icon(Icons.access_time, color: DMColors.black, size: 15)
                  : SvgPicture.asset("assets/icons/check.svg",
                      color: DMColors.green, height: 15, width: 15),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                          isOnGoingLeave ? "Leave ongoing" : "Leave taken from",
                          style: DMTypo.bold14BlackTextStyle))),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(getDayCount(),
                      style: DMTypo.bold14PrimaryBlueTextStyle))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 25),
                  child: Text(getDateInterval(),
                      style: DMTypo.bold12MutedTextStyle),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getDayCount() {
    return leaveEntry.startDate.getDifferenceInDays(leaveEntry.endDate);
  }

  String getDateInterval() {
    final DateFormat format = DateFormat("d MMM yyyy");
    return "${format.format(leaveEntry.startDate)} - ${format.format(leaveEntry.endDate)}";
  }
}
