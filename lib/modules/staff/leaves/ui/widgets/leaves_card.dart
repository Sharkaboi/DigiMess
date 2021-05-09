import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/modules/staff/leaves/data/util/leaves_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class LeaveCard extends StatelessWidget {
  final LeavesWrapper leave;

  const LeaveCard({Key key, this.leave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final bool isOnGoingLeave = (leave.leaveEntry.startDate.compareTo(now) <= 0 &&
        leave.leaveEntry.endDate.copyWith(day: leave.leaveEntry.endDate.day + 1).compareTo(now) >=
            0);
    return Container(
      margin: EdgeInsets.all(20).copyWith(top: 0),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
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
                      child: Text(getTitle(isOnGoingLeave), style: DMTypo.bold14BlackTextStyle))),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(getDayCount(), style: DMTypo.bold14PrimaryBlueTextStyle))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 25),
                  child: Text(getDateInterval(), style: DMTypo.bold12MutedTextStyle),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String getDayCount() {
    return leave.leaveEntry.startDate.getDifferenceInDays(leave.leaveEntry.endDate);
  }

  String getDateInterval() {
    final DateFormat format = DateFormat("d MMM yyyy");
    return "${format.format(leave.leaveEntry.startDate)} - ${format.format(leave.leaveEntry.endDate)}";
  }

  String getTitle(isOnGoingLeave) {
    return "${leave.user.username} - ${leave.user.name}";
  }
}
