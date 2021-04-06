import 'package:DigiMess/common/constants/branch_types.dart';
import 'package:DigiMess/common/firebase/models/user.dart';
import 'package:DigiMess/common/styles/dm_colors.dart';
import 'package:DigiMess/common/styles/dm_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ProfileCard extends StatelessWidget {
  final User userDetails;

  const ProfileCard({Key key, this.userDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 60),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: DMColors.black.withOpacity(0.25),
                  offset: Offset(0, 4),
                  blurRadius: 4)
            ], color: DMColors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 120),
                    child: Text(userDetails.name,
                        style: DMTypo.bold18BlackTextStyle,
                        textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30)
                        .copyWith(bottom: 0),
                    child: Text("Admission number",
                        style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.username,
                        style: DMTypo.bold16PrimaryBlueTextStyle,
                        textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        .copyWith(bottom: 0),
                    child:
                        Text("Email ID", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.email,
                        style: DMTypo.bold16PrimaryBlueTextStyle,
                        textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        .copyWith(bottom: 0),
                    child: Text("Date of Birth",
                        style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(getDob(),
                        style: DMTypo.bold16PrimaryBlueTextStyle,
                        textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        .copyWith(bottom: 0),
                    child: Text("Batch", style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(getBatch(),
                        style: DMTypo.bold16PrimaryBlueTextStyle,
                        textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        .copyWith(bottom: 0),
                    child: Text("Phone number",
                        style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20).copyWith(top: 5),
                    child: Text(userDetails.phoneNumber,
                        style: DMTypo.bold16PrimaryBlueTextStyle,
                        textAlign: TextAlign.center)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        .copyWith(bottom: 0),
                    child: Text("Food preference",
                        style: DMTypo.bold16BlackTextStyle)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                        .copyWith(top: 5),
                    child: Text((userDetails.isVeg ? "Veg" : "Non-veg"),
                        style: DMTypo.bold16PrimaryBlueTextStyle,
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: DMColors.black.withOpacity(0.25),
                  offset: Offset(0, 4),
                  blurRadius: 4)
            ], color: DMColors.white, shape: BoxShape.circle),
            child: SvgPicture.asset("assets/icons/profile_circle.svg",
                height: 150, width: 150),
          )
        ],
      ),
    );
  }

  String getDob() {
    if (userDetails == null || userDetails.dob == null) {
      return "DOB unavailable";
    } else {
      final DateFormat format = DateFormat("d/MM/yyyy");
      return format.format(userDetails.dob);
    }
  }

  String getBatch() {
    if (userDetails == null ||
        userDetails.yearOfAdmission == null ||
        userDetails.yearOfCompletion == null ||
        userDetails.branch == null) {
      return "Batch unavailable";
    } else {
      return "${userDetails.branch.toStringValue()} ${userDetails.yearOfAdmission.year}-${userDetails.yearOfCompletion.year}";
    }
  }
}
