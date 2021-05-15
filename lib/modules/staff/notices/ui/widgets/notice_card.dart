import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeCard extends StatelessWidget {
  final Notice notice;

  const NoticeCard({Key key, this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20).copyWith(top: 0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child: Text(notice.title ?? "Notice", style: DMTypo.bold14BlackTextStyle)),
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(getDate(), style: DMTypo.bold12MutedTextStyle))
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
