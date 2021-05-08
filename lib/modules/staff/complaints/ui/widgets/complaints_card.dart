import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintsCard extends StatelessWidget {
  final Complaint complaints;

  const ComplaintsCard({Key key,this.complaints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String complaintCategory = complaints.categories.join(", ");
    String complaintUser = complaints.user.toString();

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 10.0),
      width: (MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: DMColors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$complaintUser",
              style: TextStyle(
                shadows: [
                  Shadow(
                    color: DMColors.black,
                    offset: Offset(0, -5),
                  ),
                ],
                fontSize: 14.0,
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationColor: DMColors.grey,
                decorationThickness: 2.0,
              ),
            ),
            Container(height: 20.0,),
            Text("Categories",
              style: DMTypo.bold14BlackTextStyle,),
            Container(height: 10.0,),
            Text("$complaintCategory",
              style: DMTypo.normal14BlackTextStyle,),
            Container(height: 20.0,),
            Text("Others",
              style: DMTypo.bold14BlackTextStyle,),
            Container(height: 10.0,),
            Text(complaints.complaint,
              style: DMTypo.normal14BlackTextStyle,),
            Container(height: 20.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Posted on ",
                  style: DMTypo.bold14MutedTextStyle,),
                Text(getDate(),
                  style: DMTypo.normal14MutedTextStyle,),
              ],
            ),
          ],
        ),
      ),
    );
  }
  String getDate() {
    if (complaints.date != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(complaints.date);
    } else {
      return "N/A";
    }
  }
}





