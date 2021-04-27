import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class NoticesCardItem extends StatelessWidget {
  final Notice notice;

  const NoticesCardItem({Key key, this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20).copyWith(bottom: 0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: DMColors.black.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/notice_alarm.svg",
                  height: 15, width: 15),
              Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(notice.title ?? "Notice",
                        style: DMTypo.bold14BlackTextStyle)),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 20, left: 25, right: 10),
              child: Row(
                children: [
                  Expanded(
                      child:
                          Text(getDate(), style: DMTypo.bold12MutedTextStyle)),
                ],
              ))
        ],
      ),
    );
  }

  String getDate() {
    if (notice == null || notice.date == null) {
      return "Date unavailable";
    } else {
      final DateFormat format = DateFormat("d MMM yyyy");
      return format.format(notice.date);
    }
  }
}
