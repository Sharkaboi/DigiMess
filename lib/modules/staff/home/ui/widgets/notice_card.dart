import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/date_extensions.dart';
import 'package:DigiMess/common/firebase/models/notice.dart';
import 'package:flutter/material.dart';

class NoticeCard extends StatelessWidget {
  final Notice latestNotice;
  final VoidCallback noticesCallback;

  const NoticeCard({Key key, this.latestNotice, this.noticesCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DMColors.white,
          border: Border.all(color: DMColors.primaryBlue, width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Icon(Icons.circle, color: DMColors.yellow, size: 10)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(latestNotice.title, style: DMTypo.bold14BlackTextStyle)),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(latestNotice.date.getTimeAgo(),
                            style: DMTypo.bold12MutedTextStyle)),
                  ],
                ),
              ),
            ],
          )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: noticesCallback,
              child: Row(
                children: [
                  Text("View more", style: DMTypo.bold12PrimaryBlueTextStyle),
                  Icon(Icons.double_arrow, color: DMColors.primaryBlue, size: 10)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
