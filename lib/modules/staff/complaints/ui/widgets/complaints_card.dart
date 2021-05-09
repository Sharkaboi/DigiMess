import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/modules/staff/complaints/data/util/complaint_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintsCard extends StatelessWidget {
  final ComplaintWrapper complaintWrapper;

  const ComplaintsCard({Key key, this.complaintWrapper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String complaintCategory =
        complaintWrapper.complaint.categories.map((e) => e.capitalizeFirst()).join(", ");
    final String complaintUser =
        "${complaintWrapper.user.username} - ${complaintWrapper.user.name}";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: DMColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: DMColors.black.withOpacity(0.25), blurRadius: 4, offset: Offset(0, 4))
          ]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(complaintUser, style: DMTypo.bold14UnderlinedBlackTextStyle),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Categories",
                style: DMTypo.bold14BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                complaintCategory,
                style: DMTypo.normal14BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Others",
                style: DMTypo.bold14BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                complaintWrapper.complaint.complaint,
                style: DMTypo.normal14BlackTextStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "Posted on ",
                      style: DMTypo.bold14BlackTextStyle,
                    ),
                  ),
                  Text(
                    getDate(),
                    style: DMTypo.normal12BlackTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDate() {
    if (complaintWrapper.complaint.date != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(complaintWrapper.complaint.date);
    } else {
      return "N/A";
    }
  }
}
