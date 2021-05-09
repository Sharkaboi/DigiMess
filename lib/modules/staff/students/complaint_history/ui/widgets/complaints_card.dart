import 'package:DigiMess/common/design/dm_colors.dart';
import 'package:DigiMess/common/design/dm_typography.dart';
import 'package:DigiMess/common/extensions/string_extensions.dart';
import 'package:DigiMess/common/firebase/models/complaint.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintsCard extends StatelessWidget {
  final Complaint complaint;

  const ComplaintsCard({Key key, this.complaint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: DMColors.black.withOpacity(0.25), offset: Offset(0, 4), blurRadius: 4)
      ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text("Categories", style: DMTypo.bold14BlackTextStyle)),
          Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(getCategories(), style: DMTypo.normal14BlackTextStyle)),
          Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text("Others", style: DMTypo.bold14BlackTextStyle)),
          Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(getTitle(), style: DMTypo.normal14BlackTextStyle)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text("Posted on", style: DMTypo.bold14BlackTextStyle),
              ),
              Text(getDate(), style: DMTypo.normal12BlackTextStyle),
            ],
          )
        ],
      ),
    );
  }

  String getDate() {
    if (complaint.date != null) {
      final DateFormat format = DateFormat("MMM d, yyyy");
      return format.format(complaint.date);
    } else {
      return "N/A";
    }
  }

  String getTitle() {
    if (complaint.complaint != null) {
      return complaint.complaint.capitalizeFirst();
    } else {
      return "N/A";
    }
  }

  String getCategories() {
    if (complaint.categories != null && complaint.categories.isNotEmpty) {
      return complaint.categories.map((e) => e.capitalizeFirst()).join(", ");
    } else {
      return "N/A";
    }
  }
}
